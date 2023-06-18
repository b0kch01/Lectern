import { messages } from "../../../../public/local";

const { Configuration, OpenAIApi } = require("openai");
require('dotenv').config();

// configuration
const configuration = new Configuration({
  apiKey: process.env.OPENAI_API_KEY,
});
const openai = new OpenAIApi(configuration);

export async function GET(request){
    if(request){
        console.log(request.headers)
        // don't really use this tbh 
        var headingValue = request.headers.get("heading") ? request.headers.get("heading") : "";
        
        var notesValue = request.headers.get("notes") ? request.headers.get("notes") : "";
        var transcriptValue = request.headers.get("transcript") ? request.headers.get("transcript") : "";
        var prevFeedBackValue = request.headers.get("previous_feedback") ? request.headers.get("previous_feedback") : "";
        var practiceSessionContextValue = request.headers.get("practice_session_context") ? JSON.parse(request.headers.get("practice_session_context")) : [];

        console.log(typeof(request.headers));
        console.log('Heading:', headingValue);
        console.log('Notes:', notesValue);
        console.log('Transcript:', transcriptValue);
        console.log('Previous Feedback:', prevFeedBackValue);
        console.log('Practice Session Context:', practiceSessionContextValue);
        console.log(typeof(practiceSessionContextValue));
      }else{
        console.log('aw poop!')
      }
    let practice_sequence_prompt = "Given the previous user-assistant interaction, based on the previous FEEDBACK content, ask open-ended questions to display the user\'s understanding of the content: 0 - 100% (100% knows everything and 0% knows nothing) - this should be a variety of questions covering different parts of the notes. These initial questions will be answered by the user, and you will help them get through the questions, gauging their understanding with a percentage score. Every time the user says something that is true from the notes, increase the percentage. But if the user is wrong, decrease the percentage. Go through this process until the user achieves >= 90% mastery of the content. Start the question section with \"START\", and end it with the word \"END\"\n\nexample:\n\nassistant:\nSTART\nUnderstanding: 0%\nQuestion 1: How does Nathan Look? \nEND\n\nuser: \nhe is short\n\nassistant:\nSTART\nUnderstanding: 0%\nComment: Remember, Nathan is cute.\nQuestion: What is Nathan\'s relationship with Paul? \nEND\n\nuser:\nNathan loves Paul.\n\nassistant:\nSTART\nUnderstanding: 50%\nComment: good job!\nQuestion: How does Nathan Look? \nEND\n\nuser:\nNathan is cute. \n\nassistant:\nSTART\nUnderstanding: 100%\nComment: good job!\nQuestion: COMPLETE\nEND\n\nWhen the user reaches >= 90% mastery, print the following: \nSTART\nQuestion: COMPLETE\nEND"
    
    // sends the conversation chatgpt api call     
    const completion = await openai.createChatCompletion({
        model: "gpt-4",
        messages: [
            {"role": "assistant", "content": `previous feedback: ${prevFeedBackValue}`},
            {"role": "assistant", "content": `user notes: ${notesValue}`},
            {"role": "assistant", "content": `${practice_sequence_prompt}`},
            ... practiceSessionContextValue,
            {"role": "user", "content": `user response: ${transcriptValue}`}
        ]
    });

    console.log(completion.data.choices[0].message);

    return new Response(`${JSON.stringify(completion.data.choices[0].message)}`);
}