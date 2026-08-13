/**
 * Format an ISO timestamp as a calendar date without shifting across the
 * UTC boundary — a plain `toLocaleDateString()` call can render the wrong
 * day when the local timezone sits behind UTC and the timestamp falls near
 * midnight.
 */
export function formatDate(iso: string): string {
	return new Date(iso).toLocaleDateString(undefined, { timeZone: 'UTC' });
}
