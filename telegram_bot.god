# encoding: utf-8

God.watch do |w|
  w.name = 'telegram_bot'
  w.start = '/home/andre/ruby_prog/telegram-bot/start_bot.rb'
  w.keepalive interval: 60
end
