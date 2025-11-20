import { WordEntry } from "../types";
import { WORD_LENGTH } from "../constants";
import WORDS_CSV from "../assets/wordlist.csv?raw";

let cachedWords: WordEntry[] | null = null;

function parseCsv(): WordEntry[] {
  if (cachedWords) return cachedWords;

  const lines = WORDS_CSV.trim().split(/\r?\n/);
  const entries: WordEntry[] = [];

  for (const raw of lines) {
    const line = raw.trim();
    if (!line || line.startsWith("#")) continue;

    const [wordPart, ...rest] = line.split(",");
    if (!wordPart || rest.length === 0) continue;

    const word = wordPart.trim().toUpperCase();
    if (word.length !== WORD_LENGTH) continue;

    const hint = rest.join(",").trim();
    entries.push({ word, hint });
  }

  cachedWords = entries;
  return entries;
}

interface EtParts {
  year: number;
  month: number;
  day: number;
  hour: number;
  minute: number;
  second: number;
}

function getEtNowParts(): EtParts {
  const now = new Date();
  const fmt = new Intl.DateTimeFormat("en-US", {
    timeZone: "America/New_York",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit",
    hour12: false,
  });

  const parts = fmt.formatToParts(now);
  const get = (type: string) =>
    Number(parts.find((p) => p.type === type)?.value ?? "0");

  return {
    year: get("year"),
    month: get("month"),
    day: get("day"),
    hour: get("hour"),
    minute: get("minute"),
    second: get("second"),
  };
}

function adjustEtPartsByDays(parts: EtParts, deltaDays: number): EtParts {
  const { year, month, day, hour, minute, second } = parts;
  const d = new Date(Date.UTC(year, month - 1, day, hour, minute, second));
  d.setUTCDate(d.getUTCDate() + deltaDays);
  const fmt = new Intl.DateTimeFormat("en-US", {
    timeZone: "America/New_York",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit",
    hour12: false,
  });
  const newParts = fmt.formatToParts(d);
  const get = (type: string) =>
    Number(newParts.find((p) => p.type === type)?.value ?? "0");
  return {
    year: get("year"),
    month: get("month"),
    day: get("day"),
    hour: get("hour"),
    minute: get("minute"),
    second: get("second"),
  };
}

function etDayIndex(year: number, month: number, day: number): number {
  const base = Date.UTC(2025, 0, 1);
  const current = Date.UTC(year, month - 1, day);
  return Math.floor((current - base) / (1000 * 60 * 60 * 24));
}

function etSecondsFromBase(p: EtParts): number {
  const dayIdx = etDayIndex(p.year, p.month, p.day);
  return dayIdx * 86400 + p.hour * 3600 + p.minute * 60 + p.second;
}

function etDateIdForGame(): string {
  let parts = getEtNowParts();

  if (parts.hour < 8) {
    parts = adjustEtPartsByDays(parts, -1);
  }

  const { year, month, day } = parts;
  const mm = String(month).padStart(2, "0");
  const dd = String(day).padStart(2, "0");
  return `${year}-${mm}-${dd}`;
}

export function getTodaySolution(): {
  entry: WordEntry;
  gameDateId: string;
} {
  const words = parseCsv();
  const dateId = etDateIdForGame();
  const [y, m, d] = dateId.split("-").map((n) => Number(n));
  const dayIdx = etDayIndex(y, m, d);
  const idx = ((dayIdx % words.length) + words.length) % words.length;
  return {
    entry: words[idx],
    gameDateId: dateId,
  };
}

export function secondsUntilNextWord(): number {
  const now = getEtNowParts();

  let target: EtParts;
  if (now.hour < 8) {
    target = { ...now, hour: 8, minute: 0, second: 0 };
  } else {
    const nextDay = adjustEtPartsByDays(now, 1);
    target = { ...nextDay, hour: 8, minute: 0, second: 0 };
  }

  const diff = etSecondsFromBase(target) - etSecondsFromBase(now);
  return Math.max(0, diff);
}

export function isValidWord(guess: string): boolean {
  const words = parseCsv();
  const upper = guess.toUpperCase();
  return words.some((w) => w.word === upper);
}

export function getHintForWord(word: string): string | null {
  const words = parseCsv();
  const upper = word.toUpperCase();
  const entry = words.find((w) => w.word === upper);
  return entry?.hint ?? null;
}
