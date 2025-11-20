export type TileStatus = "empty" | "editing" | "correct" | "present" | "absent";

export type GameStatus = "IN_PROGRESS" | "WON" | "LOST";

export interface WordEntry {
  word: string;
  hint: string;
}

export interface GuessResult {
  letters: TileStatus[];
}

export interface GameState {
  gameDateId: string;
  solution: string;
  solutionHint: string;
  guesses: string[];
  results: GuessResult[];
  status: GameStatus;
  usedHint: boolean;
}

export interface StatsState {
  played: number;
  won: number;
  streak: number;
  maxStreak: number;
}

export interface ToastMessage {
  id: number;
  text: string;
}
