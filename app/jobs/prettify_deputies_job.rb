class PrettifyDeputiesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Deputy.all.each do |deputy|
      deputy.prettify
    end
  end
end
