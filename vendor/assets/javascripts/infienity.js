!function(e){var t={};function i(n){if(t[n])return t[n].exports;var r=t[n]={i:n,l:!1,exports:{}};return e[n].call(r.exports,r,r.exports,i),r.l=!0,r.exports}i.m=e,i.c=t,i.d=function(e,t,n){i.o(e,t)||Object.defineProperty(e,t,{enumerable:!0,get:n})},i.r=function(e){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},i.t=function(e,t){if(1&t&&(e=i(e)),8&t)return e;if(4&t&&"object"==typeof e&&e&&e.__esModule)return e;var n=Object.create(null);if(i.r(n),Object.defineProperty(n,"default",{enumerable:!0,value:e}),2&t&&"string"!=typeof e)for(var r in e)i.d(n,r,function(t){return e[t]}.bind(null,r));return n},i.n=function(e){var t=e&&e.__esModule?function(){return e.default}:function(){return e};return i.d(t,"a",t),t},i.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},i.p="",i(i.s=0)}([function(e,t){class i{constructor(e,t,i){this._fetchNextEntriesFuncName=t,this._isFieQueried=!1,this._params=i,this._fie=e,this._loadNewEntries=this._loadNewEntries.bind(this),this.fieResponded=this.fieResponded.bind(this),this.bindEvents()}bindEvents(){document.addEventListener("fieReady",e=>this._loadNewEntries(!0)),window.addEventListener("scroll",this._loadNewEntries)}unbindEvents(){window.removeEventListener("scroll",this._loadNewEntries)}fieResponded(e=!1){this._isFieQueried=!1,window.setTimeout(t=>{e&&this._loadNewEntries(!0)},300)}setFieAsQueried(){self=this,this._isFieQueried=!0,window.setTimeout(e=>{self._isFieQueried=!1},300)}_loadNewEntries(e=!1){if(this.isUserBelowBottom()&&0==this._isFieQueried){let t={pagination_params:this._params,is_first_load:1==e};this._fie.executeCommanderMethod(this._fetchNextEntriesFuncName,t),this.setFieAsQueried()}}isUserBelowBottom(){return window.scrollY+window.innerHeight>this.lastEntryOffset()}lastEntryOffset(e=10){const t=document.querySelector(".paginate");return t.offsetTop+t.offsetHeight-window.innerHeight*e/100}}document.addEventListener("DOMContentLoaded",e=>{const t=document.querySelector(".paginate").getAttribute("infienity-model");window.Infienity=new i(Fie,`paginate_${t}`,{})})}]);