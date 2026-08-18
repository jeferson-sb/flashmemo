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
	user_id: number;
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
	user_id: number;
	title: string;
	level: string;
	total: number;
	category?: string;
	questions: ExamQuestion[];
}

export type ImportStatus = 'pending' | 'processing' | 'completed' | 'failed';

export interface ImportRowError {
	row: number;
	title: string;
	reason: string;
}

/** GET /api/imports/:id — the polled state of a spreadsheet import. */
export interface QuestionImport {
	id: number;
	exam_id: number;
	status: ImportStatus;
	filename: string | null;
	total_rows: number;
	imported_count: number;
	skipped_count: number;
	failed_count: number;
	failure_reason: string | null;
	created_at: string;
	row_errors: ImportRowError[];
}

/** GET /api/mindmaps — Neo4j node ids are opaque UUID strings, not AR ids. */
export interface MindMapListItem {
	id: number;
	name: string;
	owner_id: number;
}

export type GraphNodeType = 'exam' | 'category';

export interface GraphNode {
	id: string;
	label: string;
	type: GraphNodeType;
}

export type GraphEdgeType = 'RELATES_TO' | 'IN';

export interface GraphEdge {
	source: string;
	target: string;
	type: GraphEdgeType;
}

/** GET /api/mindmaps/:mindmap_id/graph */
export interface MindMapGraph {
	nodes: GraphNode[];
	edges: GraphEdge[];
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
