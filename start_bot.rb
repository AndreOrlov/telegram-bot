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

goroscop = {
    '/овен'     => 'aries',
    '/телец'    => 'taurus',
    '/близнецы' => 'gemini',
    '/рак'      => 'cancer',
    '/лев'      => 'leo',
    '/дева'     => 'virgo',
    '/весы'     => 'libra',
    '/скорпион' => 'scorpio',
    '/стрелец'  => 'sagittarius',
    '/козерог'  => 'capricorn',
    '/водолей'  => 'aquarius',
    '/рыбы'     => 'pisces',
}

def get_xml(url)
  if (response = Net::HTTP.get_response(URI(url)) rescue nil).kind_of? Net::HTTPSuccess
    Nokogiri::XML(response.body) rescue nil
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
        url = "http://rzhunemogu.ru/Rand.aspx?CType=#{rzhu[t]}"

        if ans = (get_xml(url).content.force_encoding('cp1251').encode('utf-8') rescue nil)
          bot.api.sendMessage(chat_id: message.chat.id, text: ans)
        end
      when goroscop.keys.include?(t)
        url = 'http://img.ignio.com/r/export/utf/xml/daily/com.xml'

        if ans = get_xml(url)
          bot.api.sendMessage(chat_id: message.chat.id, text: 'test') #ans)
        end
    end
  end
end

