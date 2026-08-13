export function reveal(node: HTMLElement) {
	if (typeof IntersectionObserver === 'undefined') {
		return {};
	}

	// Only arm (hide, then animate in) once we know we can observe and
	// reveal it again — otherwise the element stays at its visible default.
	node.classList.add('reveal--armed');

	const observer = new IntersectionObserver(
		(entries) => {
			for (const entry of entries) {
				if (entry.isIntersecting) {
					entry.target.classList.add('is-visible');
					observer.unobserve(entry.target);
				}
			}
		},
		{ threshold: 0.2, rootMargin: '0px 0px -10% 0px' }
	);

	observer.observe(node);

	return {
		destroy() {
			observer.disconnect();
		}
	};
}
