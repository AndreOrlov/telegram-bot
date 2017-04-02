#!/usr/bin/env ruby

require 'telegram/bot'
require 'net/http'
require 'nokogiri'

require_relative 'token'

rzhu = {
    '/anekdot' => 1,
    '/anecdot' => 1,
    '/aforizm' => 4,
    '/tost'    => 6,
}

def get_xml(url)
  if (response = Net::HTTP.get_response(URI(url)) rescue nil).kind_of? Net::HTTPSuccess
    Nokogiri::XML(response.body).content.force_encoding('cp1251').encode('utf-8') rescue nil
  end
end

Telegram::Bot::Client.run(@token) do |bot|
  bot.listen do |message|
    case # message.text
      when '/help' == (t = message.text)
        bot.api.sendMessage(chat_id: message.chat.id, text: "My commands:\r\n/help - list of commands\r\n/start - hello\r\n/anekdot - anekdot\r\n/aforizm - aforizm\r\n/tost - tost")
      when '/start' == t
        bot.api.sendMessage(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
      when rzhu.keys.include?(t)
        url = "http://riizhunemogu.ru/Rand.aspx?CType=#{rzhu[t]}"

        if ans = get_xml(url)
          bot.api.sendMessage(chat_id: message.chat.id, text: ans)
        end
    end
  end
end

