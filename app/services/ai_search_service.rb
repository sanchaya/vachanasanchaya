require 'net/http'
require 'json'
require 'uri'

class AiSearchService
  ModelInfo = Class.new do
    attr_accessor :id, :label, :pricing
    def initialize(id:, label:, pricing:)
      @id = id; @label = label; @pricing = pricing
    end
  end

  PROVIDERS = {
    openai: {
      name: "OpenAI",
      base_url: "https://api.openai.com/v1/chat/completions",
      auth: ->(key) { "Bearer #{key}" },
      models: [
        ModelInfo.new(id: "gpt-4o-mini", label: "GPT-4o Mini", pricing: "cheap (~$0.15/1M tokens)"),
        ModelInfo.new(id: "gpt-4o", label: "GPT-4o", pricing: "paid (~$2.50/1M tokens)"),
        ModelInfo.new(id: "gpt-3.5-turbo", label: "GPT-3.5 Turbo", pricing: "cheap (~$0.50/1M tokens)")
      ]
    },
    openrouter: {
      name: "OpenRouter",
      base_url: "https://openrouter.ai/api/v1/chat/completions",
      auth: ->(key) { "Bearer #{key}" },
      models: [
        ModelInfo.new(id: "google/gemini-2.0-flash-001", label: "Gemini 2.0 Flash", pricing: "FREE tier available"),
        ModelInfo.new(id: "meta-llama/llama-3.3-70b-instruct", label: "Llama 3.3 70B", pricing: "FREE tier available"),
        ModelInfo.new(id: "deepseek/deepseek-chat", label: "DeepSeek V3", pricing: "cheap"),
        ModelInfo.new(id: "qwen/qwen-2.5-72b-instruct", label: "Qwen 2.5 72B", pricing: "FREE tier available"),
        ModelInfo.new(id: "microsoft/phi-3-mini-128k-instruct", label: "Phi-3 Mini", pricing: "FREE"),
        ModelInfo.new(id: "anthropic/claude-3.5-haiku", label: "Claude 3.5 Haiku", pricing: "paid (~$1/1M tokens)"),
        ModelInfo.new(id: "cohere/command-r-plus-08-2024", label: "Command R+", pricing: "FREE tier available"),
        ModelInfo.new(id: "mistralai/mistral-7b-instruct", label: "Mistral 7B", pricing: "FREE")
      ],
      extra_headers: -> {
        { "HTTP-Referer" => "https://vachana.sanchaya.net", "X-Title" => "Vachana Sanchaya" }
      }
    },
    groq: {
      name: "Groq (free!)",
      base_url: "https://api.groq.com/openai/v1/chat/completions",
      auth: ->(key) { "Bearer #{key}" },
      models: [
        ModelInfo.new(id: "llama-3.3-70b-versatile", label: "Llama 3.3 70B", pricing: "FREE (rate-limited)"),
        ModelInfo.new(id: "llama-3.1-8b-instant", label: "Llama 3.1 8B", pricing: "FREE (rate-limited)"),
        ModelInfo.new(id: "mixtral-8x7b-32768", label: "Mixtral 8x7B", pricing: "FREE (rate-limited)"),
        ModelInfo.new(id: "gemma2-9b-it", label: "Gemma 2 9B", pricing: "FREE (rate-limited)")
      ]
    },
    together: {
      name: "Together AI (free!)",
      base_url: "https://api.together.xyz/v1/chat/completions",
      auth: ->(key) { "Bearer #{key}" },
      models: [
        ModelInfo.new(id: "meta-llama/Llama-3.2-3B-Instruct-Turbo", label: "Llama 3.2 3B", pricing: "FREE (rate-limited)"),
        ModelInfo.new(id: "microsoft/Phi-3.5-mini-instruct", label: "Phi-3.5 Mini", pricing: "FREE (rate-limited)"),
        ModelInfo.new(id: "Qwen/Qwen2.5-7B-Instruct-Turbo", label: "Qwen 2.5 7B", pricing: "FREE (rate-limited)"),
        ModelInfo.new(id: "mistralai/Mistral-7B-Instruct-v0.3", label: "Mistral 7B v0.3", pricing: "FREE (rate-limited)"),
        ModelInfo.new(id: "google/gemma-2-9b-it", label: "Gemma 2 9B", pricing: "FREE (rate-limited)")
      ]
    },
    google: {
      name: "Google Gemini (free!)",
      base_url: "https://generativelanguage.googleapis.com/v1beta/models",
      auth: ->(key) { key },
      models: [
        ModelInfo.new(id: "gemini-2.0-flash", label: "Gemini 2.0 Flash", pricing: "FREE (60 req/min)"),
        ModelInfo.new(id: "gemini-2.0-flash-lite", label: "Gemini 2.0 Flash Lite", pricing: "FREE (60 req/min)"),
        ModelInfo.new(id: "gemini-1.5-flash", label: "Gemini 1.5 Flash", pricing: "FREE (60 req/min)"),
        ModelInfo.new(id: "gemini-1.5-pro", label: "Gemini 1.5 Pro", pricing: "paid (free tier available)")
      ]
    },
    anthropic: {
      name: "Anthropic",
      base_url: "https://api.anthropic.com/v1/messages",
      auth: ->(key) { "Bearer #{key}" },
      models: [
        ModelInfo.new(id: "claude-sonnet-4-20250514", label: "Claude Sonnet 4", pricing: "paid (~$3/1M tokens)"),
        ModelInfo.new(id: "claude-3-5-haiku-20241022", label: "Claude 3.5 Haiku", pricing: "paid (~$1/1M tokens)")
      ],
      extra_headers: -> { { "anthropic-version" => "2023-06-01" } }
    }
  }

  FREE_MODELS = [
    ["openrouter", "google/gemini-2.0-flash-001"],
    ["openrouter", "meta-llama/llama-3.3-70b-instruct"],
    ["openrouter", "microsoft/phi-3-mini-128k-instruct"],
    ["openrouter", "mistralai/mistral-7b-instruct"],
    ["openrouter", "cohere/command-r-plus-08-2024"],
    ["openrouter", "qwen/qwen-2.5-72b-instruct"],
    ["groq", "llama-3.3-70b-versatile"],
    ["groq", "llama-3.1-8b-instant"],
    ["groq", "mixtral-8x7b-32768"],
    ["groq", "gemma2-9b-it"],
    ["together", "meta-llama/Llama-3.2-3B-Instruct-Turbo"],
    ["together", "microsoft/Phi-3.5-mini-instruct"],
    ["together", "Qwen/Qwen2.5-7B-Instruct-Turbo"],
    ["together", "mistralai/Mistral-7B-Instruct-v0.3"],
    ["together", "google/gemma-2-9b-it"],
    ["google", "gemini-2.0-flash"],
    ["google", "gemini-2.0-flash-lite"],
    ["google", "gemini-1.5-flash"]
  ]

  def initialize(query, api_key: nil, provider: :openai, model: nil)
    @query = query.to_s.strip
    @api_key = api_key.presence
    @provider = provider.to_sym
    @provider = :openai unless PROVIDERS.key?(@provider)
    @model = model.presence || PROVIDERS[@provider][:models].first.id
  end

  def call
    return { error: "Search query cannot be blank." } if @query.blank?
    return { error: "Enter an API key for #{PROVIDERS[@provider][:name]} to use AI search." } if @api_key.blank?

    sources = fetch_relevant_vachanas
    prompt = build_prompt(sources)

    response = send_query(prompt)
    return { error: response } if response.is_a?(String)

    {
      answer: response,
      sources: sources[:vachanas],
      search_summary: sources[:summary],
      provider: @provider.to_s,
      model: @model
    }
  end

  def self.models_for(provider)
    PROVIDERS.dig(provider.to_sym, :models) || []
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
    keywords = KeyWord.where(word: words)
    vachana_ids = keywords.flat_map { |kw| kw.vachana_ids.keys }
    vachana_ids.empty? ? Vachana.none : Vachana.where(id: vachana_ids.uniq)
  end

  def search_keywords_like(words)
    return Vachana.none if words.blank?
    like_conditions = words.map { |w| "word LIKE #{ActiveRecord::Base.connection.quote("%#{w}%")}" }.join(" OR ")
    keywords = KeyWord.where(like_conditions)
    vachana_ids = keywords.flat_map { |kw| kw.vachana_ids.keys }
    vachana_ids.empty? ? Vachana.none : Vachana.where(id: vachana_ids.uniq)
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

  def send_query(prompt)
    case @provider
    when :openai, :openrouter, :groq, :together then query_openai_compat(prompt)
    when :anthropic then query_anthropic(prompt)
    when :google then query_google(prompt)
    else query_openai_compat(prompt)
    end
  end

  def query_openai_compat(prompt)
    config = PROVIDERS[@provider]
    uri = URI.parse(config[:base_url])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 120
    http.open_timeout = 15

    request = Net::HTTP::Post.new(uri.path)
    request["Authorization"] = config[:auth].call(@api_key)
    request["Content-Type"] = "application/json"

    if config[:extra_headers]
      config[:extra_headers].call.each { |k, v| request[k] = v }
    end

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

    result = JSON.parse(http.request(request).body)
    if result["error"]
      friendly_error(result["error"])
    elsif result["choices"] && result["choices"][0]
      result["choices"][0]["message"]["content"].strip
    else
      "Unexpected API response format."
    end
  rescue => e
    "Request failed: #{e.message}"
  end

  def friendly_error(err)
    msg = err['message'].to_s
    code = err['code']

    if msg.include?("tokens limit exceeded") || msg.include?("context_length_exceeded")
      "The prompt is too long for the selected model. Try a shorter query, choose a model with a larger context window, or use a paid plan."
    elsif code == 402 || msg.include?("insufficient_quota") || msg.include?("payment required")
      "The selected model requires a paid plan. Try a different model (select a FREE one from the dropdown) or add credits to your account."
    elsif msg.include?("invalid_api_key") || msg.include?("Incorrect API key") || msg.include?("authentication")
      "The API key appears to be invalid. Double-check the key for #{PROVIDERS[@provider][:name]} and try again."
    elsif msg.include?("rate limit") || msg.include?("Rate limit") || msg.include?("too many requests")
      "Rate limit exceeded. Please wait a moment and try again."
    elsif msg.include?("model_not_found") || msg.include?("not found")
      "The selected model is not available on #{PROVIDERS[@provider][:name]}. Choose a different model."
    elsif msg.include?("timeout") || msg.include?("timed out")
      "The request timed out. The model may be overloaded — try a different model."
    else
      "#{PROVIDERS[@provider][:name]} error: #{msg}"
    end
  end

  def query_anthropic(prompt)
    uri = URI.parse(PROVIDERS[:anthropic][:base_url])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 120
    http.open_timeout = 15

    request = Net::HTTP::Post.new(uri.path)
    request["x-api-key"] = @api_key
    request["anthropic-version"] = "2023-06-01"
    request["Content-Type"] = "application/json"

    body = {
      model: @model,
      max_tokens: 2000,
      temperature: 0.7,
      system: "You are a Kannada Vachana literature research scholar. Respond in Kannada with English terms in parentheses where helpful. Be insightful, cite specific vachanas, and provide scholarly analysis.",
      messages: [
        { role: "user", content: prompt }
      ]
    }
    request.body = body.to_json

    result = JSON.parse(http.request(request).body)
    if result["error"]
      "API error: #{result['error']['message']}"
    elsif result["content"] && result["content"][0]
      result["content"][0]["text"].strip
    else
      "Unexpected API response format."
    end
  rescue => e
    "Request failed: #{e.message}"
  end

  def query_google(prompt)
    uri = URI.parse("#{PROVIDERS[:google][:base_url]}/#{@model}:generateContent?key=#{@api_key}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 120
    http.open_timeout = 15

    request = Net::HTTP::Post.new(uri.request_uri)
    request["Content-Type"] = "application/json"

    body = {
      contents: [
        { role: "user", parts: [{ text: prompt }] }
      ],
      system_instruction: {
        parts: [{ text: "You are a Kannada Vachana literature research scholar. Respond in Kannada with English terms in parentheses where helpful. Be insightful, cite specific vachanas, and provide scholarly analysis." }]
      },
      generation_config: {
        temperature: 0.7,
        max_output_tokens: 2000
      }
    }
    request.body = body.to_json

    result = JSON.parse(http.request(request).body)
    if result["error"]
      friendly_error(result["error"])
    elsif result["candidates"] && result["candidates"][0]
      result["candidates"][0]["content"]["parts"][0]["text"].strip
    else
      "Unexpected API response format."
    end
  rescue => e
    "Request failed: #{e.message}"
  end
end
