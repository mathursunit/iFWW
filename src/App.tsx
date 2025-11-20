import React, { useEffect, useState, useCallback } from "react";
import Header from "./components/Header";
import GameGrid from "./components/GameGrid";
import Keyboard from "./components/Keyboard";
import StatsModal from "./components/StatsModal";
import EndGameModal from "./components/EndGameModal";
import Toasts from "./components/Toasts";

import {
  GameState,
  GameStatus,
  StatsState,
  TileStatus,
  ToastMessage,
} from "./types";
import {
  MAX_GUESSES,
  STORAGE_GAME_STATE,
  STORAGE_STATS,
  WORD_LENGTH,
} from "./constants";
import {
  getTodaySolution,
  secondsUntilNextWord,
  isValidWord,
  getHintForWord,
} from "./services/wordService";

declare const confetti: any;

const defaultStats: StatsState = {
  played: 0,
  won: 0,
  streak: 0,
  maxStreak: 0,
};

const App: React.FC = () => {
  const [{ gameState, stats }, setData] = useState<{
    gameState: GameState;
    stats: StatsState;
  }>(() => {
    const { entry, gameDateId } = getTodaySolution();

    let initialStats = defaultStats;
    const statsRaw = localStorage.getItem(STORAGE_STATS);
    if (statsRaw) {
      try {
        initialStats = { ...defaultStats, ...JSON.parse(statsRaw) };
      } catch {
        //
      }
    }

    const savedRaw = localStorage.getItem(STORAGE_GAME_STATE);
    if (savedRaw) {
      try {
        const saved: GameState = JSON.parse(savedRaw);
        if (saved.gameDateId === gameDateId) {
          return { gameState: saved, stats: initialStats };
        }
      } catch {
        //
      }
    }

    const freshGame: GameState = {
      gameDateId,
      solution: entry.word,
      solutionHint: entry.hint,
      guesses: [],
      results: [],
      status: "IN_PROGRESS",
      usedHint: false,
    };

    return { gameState: freshGame, stats: initialStats };
  });

  const [currentGuess, setCurrentGuess] = useState("");
  const [letterStatuses, setLetterStatuses] = useState<Record<string, TileStatus>>(
    {}
  );
  const [statsOpen, setStatsOpen] = useState(false);
  const [endOpen, setEndOpen] = useState(
    gameState.status === "WON" || gameState.status === "LOST"
  );
  const [revealRowIndex, setRevealRowIndex] = useState<number | null>(null);
  const [toasts, setToasts] = useState<ToastMessage[]>([]);
  const [nextSeconds, setNextSeconds] = useState(secondsUntilNextWord());

  useEffect(() => {
    localStorage.setItem(STORAGE_GAME_STATE, JSON.stringify(gameState));
  }, [gameState]);

  useEffect(() => {
    localStorage.setItem(STORAGE_STATS, JSON.stringify(stats));
  }, [stats]);

  useEffect(() => {
    const id = setInterval(() => {
      setNextSeconds(secondsUntilNextWord());
    }, 1000);
    return () => clearInterval(id);
  }, []);

  useEffect(() => {
    const newStatuses: Record<string, TileStatus> = {};
    const priority: TileStatus[] = ["absent", "present", "correct"];

    const better = (oldStatus: TileStatus | undefined, next: TileStatus) => {
      if (!oldStatus) return true;
      return priority.indexOf(next) > priority.indexOf(oldStatus);
    };

    gameState.results.forEach((res, row) => {
      const guess = gameState.guesses[row];
      res.letters.forEach((st, idx) => {
        const ch = guess[idx];
        if (!ch) return;
        if (st === "empty" || st === "editing") return;
        if (better(newStatuses[ch], st)) {
          newStatuses[ch] = st;
        }
      });
    });

    setLetterStatuses(newStatuses);
  }, [gameState.results, gameState.guesses]);

  const pushToast = useCallback((text: string) => {
    setToasts((prev) => {
      const id = Date.now() + Math.random();
      const next = [...prev, { id, text }];
      setTimeout(() => {
        setToasts((curr) => curr.filter((t) => t.id !== id));
      }, 2000);
      return next;
    });
  }, []);

  const evaluateGuess = (guess: string, solution: string): TileStatus[] => {
    const result: TileStatus[] = Array(WORD_LENGTH).fill("absent");
    const solLetters = solution.split("");
    const guessLetters = guess.split("");
    const used = Array(WORD_LENGTH).fill(false);

    for (let i = 0; i < WORD_LENGTH; i++) {
      if (guessLetters[i] === solLetters[i]) {
        result[i] = "correct";
        used[i] = true;
      }
    }

    for (let i = 0; i < WORD_LENGTH; i++) {
      if (result[i] === "correct") continue;
      const ch = guessLetters[i];
      const idx = solLetters.findIndex((s, j) => !used[j] && s === ch);
      if (idx !== -1) {
        result[i] = "present";
        used[idx] = true;
      }
    }

    return result;
  };

  const applyGameEndToStats = (prevStats: StatsState, status: GameStatus): StatsState => {
    const next: StatsState = { ...prevStats };
    next.played += 1;
    if (status === "WON") {
      next.won += 1;
      next.streak += 1;
      if (next.streak > next.maxStreak) next.maxStreak = next.streak;
    } else {
      next.streak = 0;
    }
    return next;
  };

  const fireConfetti = () => {
    if (typeof confetti !== "function") return;

    const opts = {
      particleCount: 120,
      spread: 60,
      origin: { y: 0.9 },
    };

    confetti({
      ...opts,
      origin: { x: 0.1, y: 0.9 },
      angle: 60,
    });
    confetti({
      ...opts,
      origin: { x: 0.9, y: 0.9 },
      angle: 120,
    });
  };

  const submitGuess = useCallback(() => {
    if (gameState.status !== "IN_PROGRESS") return;
    const guess = currentGuess.toUpperCase().trim();

    if (guess.length !== WORD_LENGTH) {
      pushToast("Not enough letters");
      return;
    }
    if (!isValidWord(guess)) {
      pushToast("Not in word list");
      return;
    }

    const evaluation = evaluateGuess(guess, gameState.solution);
    const newResults = [...gameState.results, { letters: evaluation }];
    const newGuesses = [...gameState.guesses, guess];
    const isWin = guess === gameState.solution;
    const isLast = newGuesses.length >= MAX_GUESSES;

    let nextStatus: GameStatus = gameState.status;
    if (isWin) nextStatus = "WON";
    else if (isLast) nextStatus = "LOST";

    const revealRow = newGuesses.length - 1;
    setRevealRowIndex(revealRow);
    setTimeout(() => setRevealRowIndex(null), WORD_LENGTH * 120);

    setData(({ gameState: gs, stats: st }) => {
      const updatedGame: GameState = {
        ...gs,
        guesses: newGuesses,
        results: newResults,
        status: nextStatus,
      };

      let updatedStats = st;
      if (nextStatus !== "IN_PROGRESS" && gs.status === "IN_PROGRESS") {
        updatedStats = applyGameEndToStats(st, nextStatus);
      }

      return { gameState: updatedGame, stats: updatedStats };
    });

    setCurrentGuess("");

    if (isWin) {
      setTimeout(() => {
        fireConfetti();
        setEndOpen(true);
      }, 650);
    } else if (isLast) {
      setTimeout(() => setEndOpen(true), 650);
    }
  }, [currentGuess, gameState, pushToast]);

  const handleKey = useCallback(
    (key: string) => {
      if (gameState.status !== "IN_PROGRESS" && key !== "ENTER") return;

      if (key === "ENTER") {
        submitGuess();
        return;
      }
      if (key === "BACKSPACE") {
        setCurrentGuess((g) => g.slice(0, -1));
        return;
      }

      if (/^[A-Z]$/.test(key) && currentGuess.length < WORD_LENGTH) {
        setCurrentGuess((g) => g + key);
      }
    },
    [currentGuess.length, gameState.status, submitGuess]
  );

  useEffect(() => {
    const onKeyDown = (e: KeyboardEvent) => {
      if (e.altKey || e.metaKey || e.ctrlKey) return;
      let key = e.key.toUpperCase();
      if (key === "ENTER") {
        e.preventDefault();
        handleKey("ENTER");
      } else if (key === "BACKSPACE") {
        e.preventDefault();
        handleKey("BACKSPACE");
      } else if (/^[A-Z]$/.test(key)) {
        e.preventDefault();
        handleKey(key);
      }
    };

    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, [handleKey]);

  const handleHint = () => {
    if (gameState.usedHint) return;
    const hint = getHintForWord(gameState.solution) ?? gameState.solutionHint;
    pushToast(hint);
    setData(({ gameState: gs, stats: st }) => ({
      gameState: { ...gs, usedHint: true },
      stats: st,
    }));
  };

  const handleShare = () => {
    const date = gameState.gameDateId;
    const won = gameState.status === "WON";
    const score = won
      ? `${gameState.guesses.length}/${MAX_GUESSES}`
      : `X/${MAX_GUESSES}`;

    const lines: string[] = [];
    lines.push(`SunSar ${date}`);
    lines.push(score);

    const emojiMap: Record<TileStatus, string> = {
      correct: "🟪",
      present: "💠",
      absent: "⬛",
      empty: "⬛",
      editing: "⬛",
    };

    for (const res of gameState.results) {
      const row = res.letters
        .slice(0, WORD_LENGTH)
        .map((st) => emojiMap[st])
        .join("");
      lines.push(row);
    }

    const text = lines.join("\n");

    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard
        .writeText(text)
        .then(() => pushToast("Copied to clipboard!"))
        .catch(() => pushToast("Unable to copy to clipboard"));
    } else {
      pushToast("Clipboard unavailable");
    }
  };

  return (
    <div className="flex min-h-screen justify-center bg-background px-3 py-4">
      <Toasts toasts={toasts} />

      <main className="flex w-full max-w-md flex-col">
        <Header
          onStatsClick={() => setStatsOpen(true)}
          onHintClick={handleHint}
          hintUsed={gameState.usedHint}
        />

        <div className="mt-4 flex flex-1 flex-col items-center">
          <GameGrid
            guesses={gameState.guesses}
            results={gameState.results.map((r) => r.letters)}
            currentGuess={currentGuess}
            revealRowIndex={revealRowIndex}
          />

          <Keyboard onKey={handleKey} letterStatuses={letterStatuses} />
        </div>
      </main>

      <StatsModal
        isOpen={statsOpen}
        onClose={() => setStatsOpen(false)}
        stats={stats}
      />

      <EndGameModal
        isOpen={endOpen}
        isWin={gameState.status === "WON"}
        solution={gameState.solution}
        secondsToNext={nextSeconds}
        onShare={handleShare}
      />
    </div>
  );
};

export default App;
