import React, { useState } from 'react';

import "./App.css";
import Exam from "./Exam";
import api from "./services/api";

function App() {
  const [exam, setExam] = useState(null);
  const [textId, setTextId] = useState("");

  if (exam) {
    return <Exam exam={exam}/>;
  }

  const getExam = async (code) => {
    const resp = await api.get(code);
    const data = resp.status === 200 ? resp.body.data : null;
    setExam(data);
  };

  const createExam = async () => {
    const resp = await api.create();
    const data = resp.status === 201 ? resp.body.data : null;
    setExam(data);
  };

  const handleTextChange = (event) => {
    setTextId(event.target.value);
  };

  const handleCreate = (event) => {
    event.preventDefault();
    createExam();
  };

  const handleContinue = (event) => {
    event.preventDefault();
    getExam(textId);
  };

  return (
    <div className="App">
      <header className="App-header">
        <p>
          Use your code to continue the exam or create a new one.
        </p>
        <a
          href="#"
          className="option"
          onClick={handleCreate}>
          New Exam
        </a>

        <input
          onChange={handleTextChange}
          value={textId}
          type="text"
          className="w-20rem mt-2rem input"/>
        <a
          href="#"
          className="option mt-2rem"
          onClick={handleContinue}>
          Continue the last
        </a>
      </header>
    </div>
  );
}

export default App;
