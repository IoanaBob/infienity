class Infienity {
	constructor(fie, funcName, params) {
	  this._fetchNextEntriesFuncName = funcName;
		this._isFieQueried = false;
		this._params = params;
		this._fie = fie;

		this._loadNewEntries = this._loadNewEntries.bind(this);
		this.fieResponded = this.fieResponded.bind(this);

		this.bindEvents();
	}

	bindEvents() {
		document.addEventListener('fieReady', _ => this._loadNewEntries(true));
		window.addEventListener('scroll', this._loadNewEntries);
	}

	unbindEvents() {
	  window.removeEventListener('scroll', this._loadNewEntries);
	}

	fieResponded(isFirstLoad = false) {
		this._isFieQueried = false;

		window.setTimeout(_ => {
			if (isFirstLoad) {
				this._loadNewEntries(true);
			}
		}, 300);
	}

	setFieAsQueried() {
	  self = this;
	  this._isFieQueried = true;

	  window.setTimeout(_ => {
			self._isFieQueried = false;
	  }, 300);
	}

	_loadNewEntries(isFirstLoad = false) {
	  if (this.isUserBelowBottom() && this._isFieQueried == false) {
			let funcParams = { pagination_params: this._params, is_first_load: isFirstLoad == true };
			this._fie.executeCommanderMethod(this._fetchNextEntriesFuncName, funcParams);
			this.setFieAsQueried();
		}
	}

	isUserBelowBottom() {
		return window.scrollY + window.innerHeight > this.lastEntryOffset();
	}

	lastEntryOffset(percentage_window_offset = 10) {
		const lastDiv = document.querySelector('.paginate')
		return lastDiv.offsetTop + lastDiv.offsetHeight - (window.innerHeight * percentage_window_offset / 100)
	}
}

document.addEventListener("DOMContentLoaded", _ => {
	const paginateElement = document.querySelector('.paginate');
	const modelName = paginateElement.getAttribute('infienity-model');

	window.Infienity = new Infienity(Fie, `paginate_${modelName}`, {});
});
