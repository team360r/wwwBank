import { useState, useCallback, useEffect } from 'react';

const STORAGE_KEY = 'wwwbank_progress';

interface QuizState {
  answers: Record<number, number>;
  revealed: boolean;
}

interface Progress {
  lastPage: string;
  visitedPages: string[];
  quizAnswers: Record<string, QuizState>;
}

const defaultProgress: Progress = {
  lastPage: '',
  visitedPages: [],
  quizAnswers: {},
};

function loadProgress(): Progress {
  if (typeof window === 'undefined') return defaultProgress;
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return defaultProgress;
    return { ...defaultProgress, ...JSON.parse(raw) };
  } catch {
    return defaultProgress;
  }
}

function saveProgress(progress: Progress) {
  if (typeof window === 'undefined') return;
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(progress));
  } catch {
    // localStorage full or unavailable
  }
}

export function useProgress() {
  const [progress, setProgress] = useState<Progress>(defaultProgress);

  useEffect(() => {
    setProgress(loadProgress());
  }, []);

  const markVisited = useCallback((pathname: string) => {
    setProgress((prev) => {
      if (prev.visitedPages.includes(pathname)) {
        const next = { ...prev, lastPage: pathname };
        saveProgress(next);
        return next;
      }
      const next = {
        ...prev,
        lastPage: pathname,
        visitedPages: [...prev.visitedPages, pathname],
      };
      saveProgress(next);
      return next;
    });
  }, []);

  const saveQuiz = useCallback(
    (chapterId: string, answers: Record<number, number>, revealed: boolean) => {
      setProgress((prev) => {
        const next = {
          ...prev,
          quizAnswers: {
            ...prev.quizAnswers,
            [chapterId]: { answers, revealed },
          },
        };
        saveProgress(next);
        return next;
      });
    },
    [],
  );

  const clearProgress = useCallback(() => {
    const cleared = { ...defaultProgress };
    saveProgress(cleared);
    setProgress(cleared);
  }, []);

  return { progress, markVisited, saveQuiz, clearProgress };
}
