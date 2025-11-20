import React from "react";
import { TileStatus } from "../types";
import { MAX_GUESSES, WORD_LENGTH } from "../constants";
import clsx from "clsx";

interface GameGridProps {
  guesses: string[];
  results: TileStatus[][];
  currentGuess: string;
  revealRowIndex: number | null;
}

const statusToClasses: Record<TileStatus, string> = {
  empty: "border border-gray-600 text-text bg-transparent",
  editing: "border border-gray-400 text-text bg-transparent",
  correct: "bg-correct text-white border border-correct",
  present: "bg-present text-white border border-present",
  absent: "bg-absent text-white border border-absent",
};

const GameGrid: React.FC<GameGridProps> = ({
  guesses,
  results,
  currentGuess,
  revealRowIndex,
}) => {
  const rows = Array.from({ length: MAX_GUESSES }, (_, rowIndex) => {
    const guess = guesses[rowIndex] || "";
    const isCurrentRow = rowIndex === guesses.length;
    const rowResult = results[rowIndex] || [];

    return Array.from({ length: WORD_LENGTH }, (_, colIndex) => {
      let letter = "";
      let status: TileStatus = "empty";

      if (guess) {
        letter = guess[colIndex] ?? "";
        status = rowResult[colIndex] ?? "editing";
      } else if (isCurrentRow && currentGuess[colIndex]) {
        letter = currentGuess[colIndex];
        status = "editing";
      }

      const isRevealing = revealRowIndex === rowIndex && !!rowResult.length;

      return (
        <div
          key={`${rowIndex}-${colIndex}`}
          className={clsx(
            "flex aspect-square items-center justify-center rounded-md text-lg font-bold uppercase",
            statusToClasses[status],
            isRevealing && "animate-tile-flip",
            "transition-colors duration-200"
          )}
          style={
            isRevealing
              ? { animationDelay: `${colIndex * 100}ms`, transformOrigin: "center" }
              : undefined
          }
        >
          {letter}
        </div>
      );
    });
  });

  return (
    <div className="mt-5 grid gap-2">
      {rows.map((row, rowIdx) => (
        <div key={rowIdx} className="grid grid-cols-5 gap-2">
          {row}
        </div>
      ))}
    </div>
  );
};

export default GameGrid;
