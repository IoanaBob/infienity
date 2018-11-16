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
	  }, 500);
	}

	_loadNewEntries(isFirstLoad = false) {
		console.log("is user below bottom??");
		console.log(this.isUserBelowBottom());
		console.log("is fie queried?");
		console.log(this._isFieQueried);

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
		const lastDiv = Array.from(document.querySelectorAll('.paginate')).pop()
		return lastDiv.offsetTop + lastDiv.offsetHeight - (window.innerHeight / percentage_window_offset)
	}
}