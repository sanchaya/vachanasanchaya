module VachanasHelper

	def get_height_for_graph
		if @vachanakaaras.count > 10
			@vachanakaaras.count * 50
		elsif @vachanakaaras.count < 5
		    @vachanakaaras.count * 200
		else
			@vachanakaaras.count * 100
		end
	end

	def format_ai_text(text)
		return "" if text.blank?
		text = text.dup
		text.gsub!(/\*\*(.+?)\*\*/, '<strong>\1</strong>')
		text.gsub!(/^(\d+)\.\s+(.+?)(?:\s*[\u2014\-–]\s*(.*))?$/) {
		  rest = $3.presence
		  if rest
		    "<div class=\"ai-section\"><span class=\"ai-section-heading\">#{$1}. #{$2}</span><div class=\"ai-section-body\">#{rest}</div></div>"
		  else
		    "<div class=\"ai-section\"><span class=\"ai-section-heading\">#{$1}. #{$2}</span></div>"
		  end
		}
		unless text.include?("<div")
		  text.gsub!(/\n\n+/, '</p><p>')
		  text = "<p>#{text}</p>"
		end
		text.html_safe
	end
end
