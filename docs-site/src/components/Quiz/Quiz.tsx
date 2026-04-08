import React, { useState, useEffect, type ReactElement } from 'react';
import { useProgress } from '../../hooks/useProgress';
import styles from './Quiz.module.css';
import QuizQuestion from './QuizQuestion';

interface QuizProps {
  chapterId: string;
  children: ReactElement | ReactElement[];
}

export default function Quiz({ chapterId, children }: QuizProps) {
  const { progress, saveQuiz } = useProgress();
  const [answers, setAnswers] = useState<Record<number, number>>({});
  const [revealed, setRevealed] = useState(false);

  const questions = React.Children.toArray(children) as ReactElement[];
  const totalQuestions = questions.length;

  useEffect(() => {
    const saved = progress.quizAnswers[chapterId];
    if (saved) {
      setAnswers(saved.answers);
      setRevealed(saved.revealed);
    }
  }, [chapterId, progress.quizAnswers]);

  const handleSelect = (questionIndex: number, optionIndex: number) => {
    if (revealed) return;
    setAnswers((prev) => ({ ...prev, [questionIndex]: optionIndex }));
  };

  const handleCheck = () => {
    setRevealed(true);
    saveQuiz(chapterId, answers, true);
  };

  const allAnswered = Object.keys(answers).length === totalQuestions;

  const score = revealed
    ? questions.reduce((acc, q, i) => {
        return acc + (answers[i] === q.props.correctIndex ? 1 : 0);
      }, 0)
    : 0;

  const scoreLabel =
    score === totalQuestions
      ? 'Perfect score!'
      : score >= totalQuestions * 0.7
        ? 'Great job!'
        : 'Keep learning!';

  const scoreEmoji =
    score === totalQuestions ? '🎉' : score >= totalQuestions * 0.7 ? '👍' : '📚';

  return (
    <div className={styles.quiz}>
      {questions.map((q, i) => (
        <QuizQuestion
          key={i}
          {...q.props}
          questionIndex={i}
          selectedAnswer={answers[i]}
          revealed={revealed}
          onSelect={handleSelect}
        />
      ))}

      {!revealed && (
        <button
          className={styles.checkButton}
          onClick={handleCheck}
          disabled={!allAnswered}
        >
          Check Answers
        </button>
      )}

      {revealed && (
        <div className={styles.scoreCard}>
          <div className={styles.scoreEmoji}>{scoreEmoji}</div>
          <div className={styles.scoreText}>
            {score} / {totalQuestions}
          </div>
          <div className={styles.scoreLabel}>{scoreLabel}</div>
        </div>
      )}
    </div>
  );
}
