const { Configuration, OpenAIApi } = require("openai");
require('dotenv').config();


// configuration
const configuration = new Configuration({
  apiKey: process.env.OPENAI_API_KEY,
});

const openai = new OpenAIApi(configuration);

export async function GET(request) {

  if (!request.headers || !request.headers.get("context") || !request.headers.get("chatHistory"))
    return new Response("No headers", { status: 400 });

  const contextPayload = request.headers.get("context").replaceAll("\n", "\\n");
  const chatHistoryRaw = request.headers.get("chatHistory").replaceAll("\\n", "\n");

  /*
  assistant:
  0% Completion
  How have the Mexican/Mexican American graduates changed?

  user:
  Their number of graduates has increased.

  assistant:
  50% Completion
  Correct; What about the Chinese?

  user:
  Their number of graduates has also increased.
  */

  console.log("JSON HISTORY", chatHistoryRaw)
  let chatHistory = JSON.parse(chatHistoryRaw);

  console.log(contextPayload.replaceAll("\\n", "\n"));

  let msg = [
    { "role": "system", "content": `You are helping someone study their notes. Given the previous user-assistant interaction, based on the previous FEEDBACK content, ask open-ended questions to display the user's understanding of the content: 0 - 100% (100% knows everything and 0% knows nothing) - this should be a variety of questions covering different parts of the notes. Every time the user says something true from the notes, increase the percentage. But if the user is wrong, decrease the percentage. Go through this process until the user achieves >= 90% mastery of the content.` },
    { "role": "user", "content": `NOTES\n{{Heading: Mexican Immigrant\'s Intergenerational Mobility}}\n{{ZZ3: Mexicans/Mexican Americans drastically changed in graduate numbers.}}\n{{ACF: Chinese have the highest educational outcomes but have virtually no intergenerational gains.}}\nEND NOTES\n\nTRANSCRIPT\nMore Mexican immigrants are now graduating compared to before.\nEND TRANSCRIPT\n\nFEEDBACK\nZZ3: Include the specific detail that the number of graduates among Mexicans/Mexican Americans has drastically changed.\nACF: Don\'t forget to mention the comparison with Chinese immigrants, specifically noting that although they have the highest educational outcomes, their intergenerational mobility hasn\'t improved significantly.\nEND FEEDBACK` },
    { "role": "assistant", "content": `0% Completion\nHow have the Mexican/Mexican American graduates changed?` },
    { "role": "user", "content": `Their number of graduates has increased.` },
    { "role": "assistant", "content": `50% Completion\nCorrect; What about the Chinese?` },
    { "role": "user", "content": `Their number of graduates has also increased.` },
    { "role": "assistant", "content": `35% Completion\nNot quite. The Chinese intergenerational mobility hasn\'t changed much. But why is this important?` },
    { "role": "user", "content": `Chinese immigrants were known for having the highest educational outcomes. Yet, their statistics have not improved over the years, unlike the Mexican/Mexican Americans. This means educational performance is not racial.` },
    { "role": "assistant", "content": `100% Completion\nGreat answer!` },
    { "role": "user", "content": contextPayload }
  ]

  const completion = await openai.createChatCompletion({
    model: "gpt-4",
    temperature: 0.95,
    messages: msg
  });

  console.log(completion.data.choices[0].message);
  return new Response(`${JSON.stringify(completion.data.choices[0].message)}`);
}