import { api } from './client';
import type {
	Category,
	Difficulty,
	EvaluateResult,
	ExamDetail,
	ExamListItem,
	GardenDetail,
	GardenListItem,
	Progress,
	PeriodFilter,
	QuestionImport,
	SessionUser
} from './types';

export const authApi = {
	login: (email: string, password: string) => api.post<{ token: string }>('/sessions', { email, password }),
	signup: (fields: { name: string; username: string; email: string; password: string }) =>
		api.post<{ message: string; token: string }>('/users', fields),
	me: () => api.get<SessionUser>('/sessions'),
	logout: () => api.del<{ message: string }>('/sessions')
};

export const categoriesApi = {
	list: () => api.get<Category[]>('/categories'),
	create: (title: string) => api.post<{ message: string }>('/categories', { title })
};

export const examsApi = {
	list: (category?: string) => api.get<ExamListItem[]>(`/exams${category ? `?category=${encodeURIComponent(category)}` : ''}`),
	get: (id: number) => api.get<ExamDetail>(`/exams/${id}`),
	create: (fields: { title: string; difficulty: Difficulty; version: number; category_id: number }) =>
		api.post<{ message: string }>('/exams', { ...fields, question_ids: [] }),
	evaluate: (examId: number, answers: { id: number; option_id: number }[]) =>
		api.post<EvaluateResult>(`/exams/${examId}/evaluate`, { questions: answers })
};

export const importsApi = {
	create: (examId: number, file: File) => {
		const body = new FormData();
		body.append('file', file);

		return api.post<QuestionImport>(`/exams/${examId}/imports`, body);
	},
	get: (id: number) => api.get<QuestionImport>(`/imports/${id}`)
};

export const questionsApi = {
	create: (fields: {
		title: string;
		exam_id: number;
		has_duo?: boolean;
		options: { text: string; correct: boolean }[];
	}) => api.post<{ message: string }>('/questions', fields)
};

export const gardensApi = {
	list: () => api.get<GardenListItem[]>('/gardens'),
	get: (id: number) => api.get<GardenDetail>(`/gardens/${id}`),
	create: () => api.post<{ message: string }>('/gardens'),
	plant: (gardenId: number, name: string) => api.post<{ message: string }>(`/gardens/${gardenId}/plant`, { name }),
	nurture: (gardenId: number, treeId: number, nutrients: number) =>
		api.post<{ message: string }>(`/gardens/${gardenId}/nurture`, { tree_id: treeId, nutrients })
};

export const usersApi = {
	progress: (userId: number, time?: PeriodFilter) =>
		api.get<Progress>(`/users/${userId}/progress${time && time !== 'all' ? `?time=${time}` : ''}`)
};
