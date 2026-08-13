export interface SessionUser {
	id: number;
	name: string;
	username: string;
	email: string;
}

export interface Category {
	id: number;
	title: string;
	created_at: string;
	updated_at: string;
}

export type Difficulty = 'beginner' | 'intermediate' | 'advanced';

/** Raw AR rows from GET /api/exams (explicit render json:, bypasses jbuilder). */
export interface ExamListItem {
	id: number;
	title: string;
	difficulty: Difficulty;
	version: number;
	created_at: string;
	updated_at: string;
	category_id: number | null;
}

export interface ExamOption {
	id: number;
	text: string;
}

export interface ExamQuestion {
	id: number;
	title: string;
	is_duo: boolean;
	options: ExamOption[];
}

/** GET /api/exams/:id (jbuilder show view). */
export interface ExamDetail {
	id: number;
	title: string;
	level: string;
	total: number;
	category?: string;
	questions: ExamQuestion[];
}

export interface GardenListItem {
	id: number;
	name: string;
	user_id: number;
	bucket_seeds: number;
	trees: number;
}

export interface GardenTree {
	id: number;
	name: string;
	phase: 'seed' | 'growing' | 'mature' | 'fall';
	health: number;
}

export interface GardenDetail {
	id: number;
	user_id: number;
	bucket_seeds: number;
	nutrients: number;
	name: string;
	trees: GardenTree[];
}

export interface Progress {
	average: number;
	exams: number[];
}

export interface EvaluateResult {
	score: number;
}

export type PeriodFilter = 'monthly' | 'yearly' | 'semester' | 'all';

/**
 * 422 bodies are inconsistent: sometimes `{ error: string[] }` (full_messages),
 * sometimes `{ error: Record<string, string[]> }` (a raw ActiveModel::Errors
 * serialization). Normalize both into a flat string list for display.
 */
export type ApiErrorBody =
	| { error: string[] }
	| { error: Record<string, string[]> }
	| { error: string };
