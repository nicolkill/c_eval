import React, {useState} from "react";

import api from "./services/api";

const QUESTIONS = [
  "Do you have a paying job?",
  "Did you consistently had a paying job for past 12 months?",
  "You own a home?",
  "You own a car?",
  "Do you have any additional source of income?",
];

const MONEY = {
  income: "What is their total monthly income from all income source? (in USD)",
  expenses: "What are their total monthly expenses? (in USD)"
};

function Exam({exam: propExam}) {
  const [credit, setCredit] = useState(null);
  const [exam, setExam] = useState(propExam);
  const [money, setMoney] = useState(0);

  const handleAnswer = async (answer, event) => {
    event.preventDefault();
    const resp = await api.answer(exam.code, answer);
    if (resp.status !== 200) {
      //  display error
      return;
    }
    setExam(resp.body.data)
  };

  const handleMoney = async (index, event) => {
    event.preventDefault();
    console.log("**********", index);

    let resp = await api[index](exam.code, money);
    if (resp.status !== 200) {
      //  display error
      return;
    }
    setExam(resp.body.data)
    setMoney(0);

    if (index === "expenses") {
      resp = await api.calculate(exam.code);
      if (resp.status !== 200) {
        //  display error
        return;
      }
      const {credit_amount, credit_score} = resp.body.data;
      setCredit({credit_amount, credit_score});
    }
  };

  const handleTextChange = (event) => {
    setMoney(event.target.value);
  };

  const moneyComponent = () => {
    const index = exam.income === null ? "income" : "expenses";
    return (
      <header className="App-header">
        <p>
          {MONEY[index]}
        </p>

        <p>
          <input
            onChange={handleTextChange}
            value={money}
            type="number"
            className="w-20rem mt-2rem input"/>
        </p>
        <p>
          <a
            className="option"
            href="#"
            onClick={handleMoney.bind(this, index)}>
            Submit
          </a>
        </p>
      </header>
    );
  };
  const questionsComponent = () => (
    <header className="App-header">
      <p>
        {QUESTIONS[exam.initial_questions.length]}
      </p>

      <p>
        <a
          className="option"
          href="#"
          onClick={handleAnswer.bind(this, true)}>
          True
        </a>
        <a
          className="option"
          href="#"
          onClick={handleAnswer.bind(this, false)}>
          False
        </a>
      </p>
    </header>
  );
  const messageComponent = (text) => (
    <header className="App-header">
      <p>
        {text}
      </p>
    </header>
  );

  const showComponent = () => {
    if (credit) {
      return messageComponent(
        <span>
          Congratulations, you have been approved for credit upto ${credit.credit_amount} amount (in USD)
          <br/>
          Your Current Credit Score is {credit.credit_score}
        </span>
      );
    }
    if (exam.score) {
      if (exam.score <= 6) {
        return messageComponent("Thank you for your answer. We are currently unable to issue credit to you")
      } else {
        return moneyComponent()
      }
    }

    return questionsComponent()
  };

  return (
    <div className="App">
      <p className="comment text-sm">
        Your exam code: <strong>{exam.code}</strong>
      </p>
      {showComponent()}
    </div>
  );
}

export default Exam;
