// Generated by CoffeeScript 1.6.1
(function(){var e,t,n,r,i,s;n=Backbone.Model.extend();s=Backbone.View.extend({tagName:"li",className:"span4",initialize:function(){this.model.on("change",this.render,this);return this.initPrizeButton()},template:_.template("        <div class='thumbnail'>            <img src='/img/plants/12345.png' />            <div class='thumbnail-head'>                <h4> <%= species %>                <%= name_ru %> </h4>                <div class='muted english'> <%= name_en %> </div>            </div>            <p class='description'> <%= description %> </p>            <div class='row push'></div>            <div class='tags badge'>                <span class='semilink'> <%= type %> </span>            </div>            <div class='order'>                <a class='btn btn-primary prize' href='#order'>                    <%= prize %>                    <span class='semispace'></span>                    <span class='ruble'>Р</span>                </a>            </div>        </div>    "),render:function(){var e;e=this.model.toJSON();this.$el.html(this.template(e));return this},initPrizeButton:function(){return $(".prize").fancybox()}});r=Backbone.Collection.extend({model:n,url:"/plants/random",refetch:function(e){var t,n,r,i;e.activeFilters.length>0?i=e.activeFilters.join("&"):i="*";t=e.height;n=e.prize;r=e.search;this.url="/plants/filters/"+i+"/"+n+"/"+t+"/"+r;return this.fetch({reset:!0})}});i=Backbone.View.extend({tagName:"ul",className:"thumbnails",initialize:function(){return this.collection.on("reset",this.addAll,this)},render:function(){console.log(123);this.addAll();return this},addOne:function(e){var t;t=new s({model:e});return this.$el.append(t.render().el)},addAll:function(){this.$el.empty();console.log(123);return this.collection.forEach(this.addOne,this)}});t=Backbone.View.extend({el:".filters",initialize:function(){return this.initSliders()},events:{"slide #prize":"changePrizeView","slide #height":"changeHeightView","slidestop #prize":"modifyPrize","slidestop #height":"modifyHeight","keyup .search":"startSearch","click .type":"toggleTypeFilter","click .source":"toggleSourceFilter"},toggleTypeFilter:function(e){var t,n,r;r=e.currentTarget;n=r.id;t=$(r).parent().parent().attr("id");this.model.toggleTypeFilter(n,t);$(r).hasClass("filter-on")?$(r).removeClass("filter-on"):$(r).addClass("filter-on");return e.stopPropagation()},toggleSourceFilter:function(e){var t;t=e.currentTarget;if(!$(t).hasClass("toggled")){_.each($(t).children().children(".type"),function(e){return $(e).addClass("filter-on")});$(t).addClass("toggled")}else{_.each($(t).children().children(".type"),function(e){return $(e).removeClass("filter-on")});$(t).removeClass("toggled")}this.model.toggleSourceFilter(t.id);return e.stopPropagation()},initSliders:function(){$("#prize").slider({range:"min",min:100,max:1e3,step:5,value:1e3});return $("#height").slider({range:"min",max:1e3,min:5,step:5,value:1e3})},modifyPrize:function(e,t){return this.model.modifyPrize(t.value)},modifyHeight:function(e,t){return this.model.modifyHeight(t.value)},changePrizeView:function(e,t){return $(".prize-view").text(t.value)},changeHeightView:function(e,t){return $(".height-view").text(t.value)},startSearch:function(e){var t=this;$("#loader").show();clearTimeout(this.loaderTimeout);return this.loaderTimeout=setTimeout(function(){t.model.setSearch($(".search").val());return $("#loader").hide()},2e3)}});e=Backbone.Model.extend({setSearch:function(e){return this.set({search:e})},modifyPrize:function(e){return this.set({prize:e})},modifyHeight:function(e){return this.set({height:e})},toggleSourceFilter:function(e){var t,n;n=this.get("filterList").source[e].type;t=_.clone(this.get("activeFilters"));_.each(n,function(e){var n;n=_.indexOf(t,e.name);if(n===-1)return t.push(e.name)});return this.set({activeFilters:t})},toggleTypeFilter:function(e,t){var n,r;e=this.get("filterList").source[t].type[e].name;n=_.clone(this.get("activeFilters"));r=_.indexOf(n,e);r!==-1?n.splice(r,1):n.push(e);return this.set({activeFilters:n})},defaults:{search:"",prize:1e3,height:1e3,activeFilters:[],filterList:{source:{own:{name:"Свои",type:{shrubs:{name:"Кустарники"},ors:{name:"Многолетники с открытой корневой системой"}}},imported:{name:"Привозные",type:{roses:{name:"Розы"},clematis:{name:"Клематисы"},conifers:{name:"Хвойные"},perennials:{name:"Многолетники"},rhododendrons:{name:"Рододендроны"},peonies:{name:"Пионы"}}}}}}});window.PlantListApp=new(Backbone.Router.extend({routes:{"":"index","filter/:query":"filter"},initialize:function(){this.filters=new e;this.filtersView=new t({model:this.filters});this.filters.on("change",this.refetchPlants,this);this.plantList=new r;this.plantListView=new i({collection:this.plantList});return $(".list").html(this.plantListView.el)},refetchPlants:function(){return this.plantList.refetch(this.filters.toJSON())},start:function(){return Backbone.history.start({pushState:!0})},index:function(){return this.plantList.fetch({reset:!0})},filter:function(e){return console.log(e)}}));$(function(){return window.PlantListApp.start()})}).call(this);