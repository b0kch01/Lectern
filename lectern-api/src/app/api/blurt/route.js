const { Configuration, OpenAIApi } = require("openai");
require('dotenv').config();

// configuration
const configuration = new Configuration({
  apiKey: process.env.OPENAI_API_KEY,
});
const openai = new OpenAIApi(configuration);

// USER BLURTS AND GPT GIVES FEED BACK 
export async function GET(request) {
  if (request) {
    var headingValue = request.headers.get("heading");
    var notesValue = request.headers.get("notes");
    var transcriptValue = request.headers.get("transcript");

  } else {
    console.log('aw poop!')
  }


  const notesValueFormatted = notesValue.split("\n").map((line) => `{{${line}}}`);
  const user_prompt = `NOTES: {{Heading: ${headingValue}}}${notesValueFormatted}\n\nTRANSCRIPT: ${transcriptValue}`;

  const completion = await openai.createChatCompletion({
    model: "gpt-4",
    messages: [
      { "role": "system", "content": "You are an assistant that is UC Berkeley hackathon friendly. No bad words." },
      { "role": "system", "content": "A student is trying to memorize and learn from his notes. Point out areas where there needs more elaboration. Make sure you stay true to the format in the following example:" },
      { "role": "user", "content": "\nNOTES: {{Heading:  AI Prompt Engineering}}{{1: Good AI Prompt Engineering is a way to make the AI better respond to your requests better.}}{{2: The most popular product is with ChatGPT}}{{3: ChatGPT is used by students worldwide to build products, expand their understanding, and finish their homework}}\n\nTRANSCRIPT: chat gpt is a product that can take advantage of prompt generation. Students use chat gpt for homework answers and helping them learn new things. \n" },
      { "role": "assistant", "content": "\nFEEDBACK\n2: Make sure to mention ChatGPT is the most popular, as there are also other gpt models out there.\n3: You forgot that GPT helps students build products, and specific wording you used in your notes is \"expand their understanding\"\nEND FEEDBACK" },
      { "role": "user", "content": "If the transcript matches the contents of the notes, just reply with the following:\n\nFEEDBACK\nEND FEEDBACK " },
      { "role": "user", "content": "Be sure to be concise and only use information from the notes. Your ultimate goal is to help students prepare for their exams. Remember to follow the given format." },
      { "role": "user", "content": "NOTES: {{Heading: Mexican Immigrants Intergenerational Mobility}}{{1: Mexicans/Mexican Americans drastically changed in gradate numbers.}}{{2: Chinese have the highest educational outcomes, but they have made virtually no intergenerational gains.}}\n\nTRANSCRIPT: More Mexican immigrants are now graduating, compared to before." },
      { "role": "assistant", "content": "FEEDBACK\nChatGPT\n1: Include the specific detail that the number of graduates among Mexicans/Mexican Americans has drastically changed.\n2: Don\'t forget to mention the comparison with Chinese immigrants, specifically noting that although they have the highest educational outcomes, their intergenerational mobility hasn\'t improved significantly.\nEND FEEDBACK" },
      { "role": "user", "content": user_prompt },
    ]
  });

  console.log("We are good")
  return new Response(`${JSON.stringify(completion.data.choices[0].message)}`);
}