# ligne très importante qui appelle les gems.
require 'http'
require 'json'
require 'dotenv'
Dotenv.load('.env')

# création de la clé d'api et indication de l'url utilisée.
api_key = ENV["OPENAI_API_KEY"]
url = "https://api.openai.com/v1/chat/completions"

# un peu de json pour faire la demande d'autorisation d'utilisation à l'api OpenAI
headers = {
  "Content-Type" => "application/json",
  "Authorization" => "Bearer #{api_key}"
}

conversation_history = []

loop do
  print "Vous: "
  user_input = gets.chomp

  conversation_history << { role: "user", content: user_input }
  
  break if user_input.downcase == "exit" 

  # Envoi du message de l'utilisateur à l'API OpenAI
  data = {
    "messages" => conversation_history,
    "max_tokens" => 150,
    "temperature" => 0.5,
    "model" => "gpt-3.5-turbo"
  }

  # Envoi de la requête à l'API OpenAI
  response = HTTP.post(url, headers: headers, body: data.to_json)
  
  # Vérification de la réponse
  if response.code == 200 # Vérification du code de réponse HTTP
    response_body = JSON.parse(response.body.to_s)
    if response_body["choices"] && response_body["choices"][0]["message"] && response_body["choices"][0]["message"]["content"]
      response_chatbot = response_body["choices"][0]["message"]["content"].strip

      puts "Bot : #{response_chatbot}"
      puts "\n" 
    else
      puts "Erreur lors de la récupération de la réponse du chatbot"
    end
  else
    break 
  end
end