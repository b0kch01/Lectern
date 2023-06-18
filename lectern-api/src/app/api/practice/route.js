import { messages } from "../../../../public/local";

const { Configuration, OpenAIApi } = require("openai");
require('dotenv').config();

// configuration
const configuration = new Configuration({
  apiKey: process.env.OPENAI_API_KEY,
});
const openai = new OpenAIApi(configuration);

//PRACTICE - GPT CONSECUTIVE QUESTION ASKING API 
export async function POST(request) {
    // TESTING

    let user_prompt = `${"change me please!"}`;
    // for asking multiple choice - quizlet multiple choice type prompt
    let testing_multiple_choice_prompt = "Given the previous user - assistant interaction, create a problem set to strengthen the user's knowledge of the notes";
    // for asking consecutive blurting questions (practice)
    let asking_open_ended_questions_prompt = "Given the previous user-assistant interaction, based on the previous FEEDBACK content, ask a simple, open-ended question to display the user\'s understanding of the content: 0 - 100% (100% knows everything and 0% knows nothing). Every time the user says something that is true from the notes, increase the percentage. But if the user is wrong, decrease the percentage. Go through this process until the user achieves >= 90% mastery of the content. Start the question section with \"START\", and end it with the word \"END\"\n\nexample:\nassistant:\nSTART\nQuestion: Is Josh tall? \nEND\n\nuser: \nhe is short\n\nassistant:\nSTART:\nUnderstanding: 0%\nComment: Remember, Josh is tall.\nQuestion: What is josh\'s name?\nEND\n\nWhen the user reaches >= 90% mastery, print the following: \nSTART\nCOMPLETE\nEND"
    const test_user_prompt = "NOTES: {{Heading: Nathan Choi}}{{1: Nathan is very cute.}}{{2: Nathan loves Paul.}}\n\nTRANSCRIPT: Nathan is Sexy and Paul is poggers."
    let test_prompt_revised = "Given the previous user-assistant interaction, based on the previous FEEDBACK content, ask an initial multiple simple, open-ended questions to display the user\'s understanding of the content: 0 - 100% (100% knows everything and 0% knows nothing) - this should be a variety of questions covering different parts of the notes. These initial questions will be answered by the user, and you will help them get through the questions, gauging their understanding with a percentage score. Every time the user says something that is true from the notes, increase the percentage. But if the user is wrong, decrease the percentage. Go through this process until the user achieves >= 90% mastery of the content. Start the question section with \"START\", and end it with the word \"END\"\n\nexample:\n\nassistant:\nSTART\nQuestion 1: How does Nathan Look? \nQuestion 2: What is Nathan\'s relationship with Paul? \nEND\n\nuser: \nhe is short\n\nassistant:\nSTART\nUnderstanding: 0%\nComment: Remember, Nathan is cute.\nQuestion: What is Nathan\'s relationship with Paul? \nEND\n\nuser:\nNathan loves Paul.\n\nassistant:\nSTART\nUnderstanding: 50%\nComment: good job!\nQuestion: How does Nathan Look? \nEND\n\nuser:\nNathan is cute. \n\nassistant:\nSTART\nUnderstanding: 100%\nComment: good job!\nQuestion: COMPLETE\nEND\n\nWhen the user reaches >= 90% mastery, print the following: \nSTART\nQuestion: COMPLETE\nEND"
    let test_assistant_context = ""
    let test_user_response = "nathan is cute"
    // TESTING

    // sends the conversation chatgpt api call     
    const completion = await openai.createChatCompletion({
        model: "gpt-4",
        messages: messages + [{"role": "assistant", "content": `${test_prompt_revised}`},
         {"role": "assistant", "content": `${test_assistant_question_context}`},
         {"role": "user", "content": `${test_user_response}`} ]
        });
    console.log(completion.data.choices[0].message);

    return new Response(`${JSON.stringify(completion.data.choices[0].message)}`);
}

// get grading from gpt 
export async function GET(request){
    const completion = await openai.createChatCompletion({
        model: "gpt-4",
        messages: messages + [{"role": "assistant", "content": `${test_prompt_revised}`}, {"role": ""} ]
        });
    console.log(completion.data.choices[0].message);

    return new Response(`${JSON.stringify(completion.data.choices[0].message)}`);
}