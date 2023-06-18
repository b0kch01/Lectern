const { Configuration, OpenAIApi } = require("openai");
require('dotenv').config();

// configuration
const configuration = new Configuration({
  apiKey: process.env.OPENAI_API_KEY,
});
const openai = new OpenAIApi(configuration);

// USER BLURTS AND GPT GIVES FEED BACK 
export async function GET(request) {
  if(request){
    console.log(request.headers)

    var headingValue = request.headers.get("heading");
    var notesValue = request.headers.get("notes");
    var transcriptValue = request.headers.get("transcript");

    console.log(typeof(request.headers))
    console.log('Heading:', headingValue);
    console.log('Notes:', notesValue);
    console.log('Transcript:', transcriptValue);
  }else{
    console.log('aw poop!')
  }

  // for asking multiple choice - quizlet multiple choice type prompt
  let testing_multiple_choice_prompt = "Given the previous user - assistant interaction, create a problem set to strengthen the user's knowledge of the notes";
  // for asking consecutive blurting questions
  let asking_open_ended_questions_prompt = "Given the previous user-assistant interaction, based on the previous FEEDBACK content, ask a simple, open-ended question to display the user\'s understanding of the content: 0 - 100% (100% knows everything and 0% knows nothing). Every time the user says something that is true from the notes, increase the percentage. But if the user is wrong, decrease the percentage. Go through this process until the user achieves >= 90% mastery of the content. Start the question section with \"START\", and end it with the word \"END\"\n\nexample:\nassistant:\nSTART\nQuestion: Is Josh tall? \nEND\n\nuser: \nhe is short\n\nassistant:\nSTART:\nUnderstanding: 0%\nComment: Remember, Josh is tall.\nQuestion: What is josh\'s name?\nEND\n\nWhen the user reaches >= 90% mastery, print the following: \nSTART\nCOMPLETE\nEND"
  let test1 = "Given the previous user-assistant interaction, based on the previous FEEDBACK content, ask an initial multiple simple, open-ended questions to display the user\'s understanding of the content: 0 - 100% (100% knows everything and 0% knows nothing) - this should be a variety of questions covering different parts of the notes. These initial questions will be answered by the user, and you will help them get through the questions, gauging their understanding with a percentage score. Every time the user says something that is true from the notes, increase the percentage. But if the user is wrong, decrease the percentage. Go through this process until the user achieves >= 90% mastery of the content. Start the question section with \"START\", and end it with the word \"END\"\n\nexample:\n\nassistant:\nSTART\nQuestion 1: How does Nathan Look? \nQuestion 2: What is Nathan\'s relationship with Paul? \nEND\n\nuser: \nhe is short\n\nassistant:\nSTART\nUnderstanding: 0%\nComment: Remember, Nathan is cute.\nQuestion: What is Nathan\'s relationship with Paul? \nEND\n\nuser:\nNathan loves Paul.\n\nassistant:\nSTART\nUnderstanding: 50%\nComment: good job!\nQuestion: How does Nathan Look? \nEND\n\nuser:\nNathan is cute. \n\nassistant:\nSTART\nUnderstanding: 100%\nComment: good job!\nQuestion: COMPLETE\nEND\n\nWhen the user reaches >= 90% mastery, print the following: \nSTART\nQuestion: COMPLETE\nEND"
  const test_user_prompt = "NOTES: {{Heading: Nathan Choi}}{{1: Nathan is very cute.}}{{2: Nathan loves Paul.}}\n\nTRANSCRIPT: Nathan is Sexy and Paul is poggers."
  
  const user_prompt = `NOTES: {{Heading: ${headingValue}}}{{${notesValue}}} \n\nTRANSCRIPT: ${transcriptValue}`;
  const completion = await openai.createChatCompletion({
    model: "gpt-4",
    messages: [
      {"role": "system", "content" : "You are an assitant that is UC Berkeley hackathon friendly. No bad words."},
      {"role": "system", "content" : "A student is trying to memorize and learn from his notes. Point out areas where there needs more elaboration. Make sure you stay true to the format in the following example:"},
      {"role": "user", "content" : "\nNOTES: {{Heading:  AI Prompt Engineering}}{{1: Good AI Prompt Engineering is a way to make the AI better respond to your requests better.}}{{2: The most popular product is with ChatGPT}}{{3: ChatGPT is used by students worldwide to build products, expand their understanding, and finish their homework}}\n\nTRANSCRIPT: chat gpt is a product that can take advantage of prompt generation. Students use chat gpt for homework answers and helping them learn new things. \n"},
      {"role": "assistant", "content": "\nFEEDBACK\n2: Make sure to mention ChatGPT is the most popular, as there are also other gpt models out there.\n3: You forgot that GPT helps students build products, and specific wording you used in your notes is \"expand their understanding\"\nEND FEEDBACK"},
      {"role": "user", "content": "If the transcript matches the contents of the notes, just reply with the following:\n\nFEEDBACK\nEND FEEDBACK "},
      {"role": "user", "content" : "Be sure to be concise and only use information from the notes. Your ultimate goal is to help students prepare for their exams. Remember to follow the given format."},
      {"role": "user", "content": "NOTES: {{Heading: Mexican Immigrants Intergenerational Mobility}}{{1: Mexicans/Mexican Americans drastically changed in gradate numbers.}}{{2: Chinese have the highest educational outcomes, but they have made virtually no intergenerational gains.}}\n\nTRANSCRIPT: More Mexican immigrants are now graduating, compared to before."},
      {"role": "assistant", "content": "FEEDBACK\nChatGPT\n1: Include the specific detail that the number of graduates among Mexicans/Mexican Americans has drastically changed.\n2: Don\'t forget to mention the comparison with Chinese immigrants, specifically noting that although they have the highest educational outcomes, their intergenerational mobility hasn\'t improved significantly.\nEND FEEDBACK"},
      {"role": "user", "content": `${user_prompt}`},
    ]
    });
  console.log(completion.data.choices[0].message);

  return new Response(`${JSON.stringify(completion.data.choices[0].message)}`);
}