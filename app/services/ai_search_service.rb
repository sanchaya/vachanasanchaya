require 'net/http'
require 'json'
require 'uri'

class AiSearchService
  API_URL = "https://api.openai.com/v1/chat/completions"

  def initialize(query, api_key = nil, model: nil)
    @query = query.to_s.strip
    @api_key = api_key.presence || ENV['OPENAI_API_KEY']
    @model = model.presence || ENV.fetch('OPENAI_MODEL', 'gpt-4o-mini')
  end

  def call
    return { error: "Search query cannot be blank." } if @query.blank?
    return { error: "Enter your OpenAI API key in the field above to use AI search." } if @api_key.blank?

    sources = fetch_relevant_vachanas
    prompt = build_prompt(sources)

    response = query_openai(prompt)
    return { error: response } if response.is_a?(String)

    {
      answer: response,
      sources: sources[:vachanas],
      search_summary: sources[:summary]
    }
  end

  private

  def fetch_relevant_vachanas
    words = extract_searchable_words

    vachanas = search_keywords_exact(words)
    method = :exact_keyword
    total = vachanas.count

    if vachanas.blank? && words.size > 1
      vachanas = search_keywords_like(words.first(3))
      method = :like_keyword
      total = vachanas.count
    end

    if vachanas.blank?
      vachanas = search_vachana_text(words.first(2))
      method = :vachana_text
      total = vachanas.count
    end

    sample = vachanas.limit(25)

    summary = case method
    when :exact_keyword then "Found #{total} vachanas matching your search terms."
    when :like_keyword then "Found #{total} vachanas with partial keyword matches."
    when :vachana_text then "Found #{total} vachanas containing your search terms in the verse text."
    else "No directly matching vachanas found in the database."
    end

    { vachanas: sample, summary: summary }
  end

  def extract_searchable_words
    kannada_words = @query.scan(/[\u0C80-\u0CFF]{3,}/)
    english_words = @query.downcase.scan(/[a-z]{3,}/)
    (kannada_words + english_words).uniq
  end

  def search_keywords_exact(words)
    return Vachana.none if words.blank?
    results = words.map { |w| KeyWord.search_vachana_pada(w, "exact_search", nil).first }.compact
    combined = results.flatten.uniq
    Vachana.where(id: combined.map(&:id))
  end

  def search_keywords_like(words)
    return Vachana.none if words.blank?
    results = words.map { |w| KeyWord.search_vachana_pada(w, "like_search", nil).first }.compact
    combined = results.flatten.uniq
    Vachana.where(id: combined.map(&:id))
  end

  def search_vachana_text(words)
    return Vachana.none if words.blank?
    conditions = words.map { |w| "vachana LIKE #{ActiveRecord::Base.connection.quote("%#{w}%")}" }.join(" OR ")
    Vachana.where(conditions)
  end

  def build_prompt(sources)
    vachanas = sources[:vachanas]
    summary = sources[:summary]

    context = if vachanas.present?
      vachanas.each_with_index.map do |v, i|
        "#{i+1}. \"#{v.vachana}\"\n   — #{v.vachanakaara.try(:name)} (ವಚನ #{v.vachanaid})"
      end.join("\n\n")
    else
      "No specific vachanas were found in the database matching this query."
    end

    <<~PROMPT.strip
      You are a research assistant specializing in Kannada Vachana literature (ವಚನ ಸಾಹಿತ್ಯ).

      A user asks: "#{@query}"

      #{summary}
      Below are the relevant vachana verses retrieved from the database. Use them as primary sources.

      #{context}

      Provide a thorough research response in Kannada (ಕನ್ನಡ), using English terms in parentheses where helpful. Cover:

      1. ಸಾರಾಂಶ (Summary) — Direct answer to the question based on the vachanas above.
      2. ಪ್ರಮುಖ ವಿಚಾರಗಳು (Key Themes) — Recurring ideas and patterns across these verses.
      3. ವಚನಕಾರರ ದೃಷ್ಟಿಕೋನ (Vachanakaara Perspectives) — How different authors approach the topic.
      4. ವಿಶ್ಲೇಷಣೆ (Analysis) — Your scholarly assessment of what these verses reveal.

      At the end, suggest 1-2 follow-up research questions the user could explore next.
    PROMPT
  end

  def query_openai(prompt)
    uri = URI.parse(API_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 90
    http.open_timeout = 15

    request = Net::HTTP::Post.new(uri.path)
    request["Authorization"] = "Bearer #{@api_key}"
    request["Content-Type"] = "application/json"

    body = {
      model: @model,
      messages: [
        { role: "system", content: "You are a Kannada Vachana literature research scholar. Respond in Kannada with English terms in parentheses where helpful. Be insightful, cite specific vachanas, and provide scholarly analysis." },
        { role: "user", content: prompt }
      ],
      temperature: 0.7,
      max_tokens: 2000
    }
    request.body = body.to_json

    response = http.request(request)
    result = JSON.parse(response.body)

    if result["error"]
      "API error: #{result['error']['message']}"
    elsif result["choices"] && result["choices"][0]
      result["choices"][0]["message"]["content"].strip
    else
      "Unexpected API response format."
    end
  rescue => e
    "Request failed: #{e.message}"
  end
end
