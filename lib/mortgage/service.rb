module Mortgage
  class Service
    class << self
      CLIENT_ID = ENV["CLIENT_ID"]
      SECRET = ENV["SECRET"]
      ACCESS_TOKEN = ENV["ACCESS_TOKEN"]
      HOST = ENV["HOST"]

      def fetch
        post_body = {
          client_id: CLIENT_ID,
          secret: SECRET,
          access_token: ACCESS_TOKEN
        }

        result = HTTP["Content-Type" => "application/json; charset=utf-8"]
          .post("#{HOST}/accounts/balance/get", json: post_body)

        if result.status.ok?
          balance = result.parse.dig("accounts").first.dig("balances", "current").to_f.round(2)
          loan = self.loan.to_f.round(2)
          paid = (loan - balance).round(2)
          progress = (paid / loan).round(3)
          { balance: balance, loan: loan, paid: paid, progress: progress }
        else
          raise StandardError, "Status: #{result.status}, Headers: #{result.headers.inspect}, Body: #{result.body.inspect}"
        end
      end

      def loan
        ENV["LOAN"].to_f
      end
    end
  end
end