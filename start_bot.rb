#!/usr/bin/env ruby

require 'telegram/bot'
require 'net/http'
require 'nokogiri'

require 'token'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
      when '/help'
        bot.api.sendMessage(chat_id: message.chat.id, text: "My commands:\r\n/help - list of commands\r\n/start - hello\r\n/anekdot - anekdot\r\n/aforizm - aforizm\r\n/tost - tost")
      when '/start'
        bot.api.sendMessage(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
      when '/anekdot',
          '/anecdot'
        url = 'http://rzhunemogu.ru/Rand.aspx?CType=1'

        if (response = Net::HTTP.get_response(URI(url)) rescue nil).kind_of? Net::HTTPSuccess
          ans = Nokogiri::XML(response.body).content.force_encoding('cp1251').encode('utf-8') rescue nil

          bot.api.sendMessage(chat_id: message.chat.id, text: ans) if ans
	end
      when '/aforizm'
        url = 'http://rzhunemogu.ru/Rand.aspx?CType=4'

        if (response = Net::HTTP.get_response(URI(url)) rescue nil).kind_of? Net::HTTPSuccess
          ans = Nokogiri::XML(response.body).content.force_encoding('cp1251').encode('utf-8') rescue nil

          bot.api.sendMessage(chat_id: message.chat.id, text: ans) if ans
        end
      when '/tost'
        url = 'http://rzhunemogu.ru/Rand.aspx?CType=6'

        if (response = Net::HTTP.get_response(URI(url)) rescue nil).kind_of? Net::HTTPSuccess
          ans = Nokogiri::XML(response.body).content.force_encoding('cp1251').encode('utf-8') rescue nil

          bot.api.sendMessage(chat_id: message.chat.id, text: ans) if ans
        end
    end
  end
end
