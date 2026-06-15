require 'net/http'
require 'json'
require 'uri'

class AiSearchService
  API_URL = "https://api.openai.com/v1/chat/completions"
  MODEL = "gpt-4o-mini"

  def initialize(query)
    @query = query.to_s.strip
    @api_key = ENV['OPENAI_API_KEY']
  end

  def call
    return { error: "Search query cannot be blank." } if @query.blank?
    return { error: "OPENAI_API_KEY not set. Please configure it in the server environment." } if @api_key.blank?

    context = fetch_relevant_vachanas
    return { error: "No vachanas found for your query." } if context[:vachanas].blank?

    response = query_openai(context[:prompt])
    return { error: "AI service error: #{response}" } if response.is_a?(String)

    {
      answer: response,
      sources: context[:vachanas]
    }
  end

  private

  def fetch_relevant_vachanas
    search_type = "exact_search"
    vachanas, word_counts, names, total = KeyWord.search_vachana_pada(@query, search_type, nil)
    return { vachanas: [], prompt: "" } if vachanas.blank?

    sample = vachanas.limit(20)
    context_text = sample.each_with_index.map do |v, i|
      "#{i+1}. #{v.vachana} --#{v.vachanakaara.try(:name)}"
    end.join("\n\n")

    prompt = build_prompt(context_text)
    { vachanas: sample, prompt: prompt }
  end

  def build_prompt(context)
    <<~PROMPT
      You are a research assistant specializing in Kannada Vachana literature (ವಚನ ಸಾಹಿತ್ಯ).
      A user has asked the following research question:

      "#{@query}"

      Below are relevant vachana verses retrieved from the database. Use them as primary sources
      to answer the question. Provide analysis in Kannada (ಕನ್ನಡ) with key terms in English
      where appropriate. Cite specific vachanas by number and author where possible.

      Relevant vachanas:
      #{context}

      Provide a thoughtful research response covering:
      1. Direct answer to the question based on the vachanas
      2. Themes and patterns observed across the verses
      3. Any notable insights about the vachanakaara's perspective
    PROMPT
  end

  def query_openai(prompt)
    uri = URI.parse(API_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 60
    http.open_timeout = 10

    request = Net::HTTP::Post.new(uri.path)
    request["Authorization"] = "Bearer #{@api_key}"
    request["Content-Type"] = "application/json"

    body = {
      model: MODEL,
      messages: [
        { role: "user", content: prompt }
      ],
      temperature: 0.7,
      max_tokens: 1500
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
