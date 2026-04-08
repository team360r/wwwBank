import React from 'react';
import styles from './Quiz.module.css';

interface QuizQuestionProps {
  question: string;
  options: string[];
  correctIndex: number;
  explanation: string;
  questionIndex: number;
  selectedAnswer: number | undefined;
  revealed: boolean;
  onSelect: (questionIndex: number, optionIndex: number) => void;
}

export default function QuizQuestion({
  question,
  options,
  correctIndex,
  explanation,
  questionIndex,
  selectedAnswer,
  revealed,
  onSelect,
}: QuizQuestionProps) {
  return (
    <div className={styles.question}>
      <div className={styles.questionText}>{question}</div>
      <div className={styles.options} role="group" aria-label={question}>
        {options.map((option, i) => {
          let className = styles.option;

          if (revealed) {
            if (i === correctIndex) {
              className += ` ${styles.optionCorrect}`;
            } else if (i === selectedAnswer) {
              className += ` ${styles.optionWrong}`;
            } else {
              className += ` ${styles.optionDimmed}`;
            }
          } else if (i === selectedAnswer) {
            className += ` ${styles.optionSelected}`;
          }

          return (
            <button
              key={i}
              className={className}
              onClick={() => !revealed && onSelect(questionIndex, i)}
              aria-pressed={i === selectedAnswer}
              disabled={revealed}
            >
              {option}
            </button>
          );
        })}
      </div>
      {revealed && (
        <div className={styles.explanation}>{explanation}</div>
      )}
    </div>
  );
}
