App = {}
_.extend App, Backbone.Events
_.extend _,
    getTypeFromName: (types, name) ->
        for x of types
            if types.hasOwnProperty x
                if types[x].name == name
                    return x


App.Plant = Plant = Backbone.Model.extend()

App.PlantView = PlantView = Backbone.View.extend(
    tagName: 'li'
    className: 'span4'   

    initialize: ()->
        @model.on 'change', @render, @
        @initPrizeButton()

    events: ()->
        "click .tags": "changeFilters"

    template: _.template("
        <div class='thumbnail'>
            <img src='/img/plants/12345.png' />
            <div class='thumbnail-head'>
                <h4> <%= species %>
                <%= name_ru %> </h4>
                <div class='muted english'> <%= name_en %> </div>
            </div>
            <p class='description'> <%= description %> </p>
            <div class='row push'></div>
            <div class='tags badge'>
                <span class='semilink'> <%= type %> </span>
            </div>
            <div class='order'>
                <a class='btn btn-primary prize' href='#order'>
                    <%= prize %>
                    <span class='semispace'></span>
                    <span class='ruble'>Р</span>
                </a>
            </div>
        </div>
    ")

    render: () ->
        attributes = @model.toJSON()
        @$el.html @template(attributes)
        @

    initPrizeButton: ()->
        $(".prize").fancybox()

    changeFilters: (event)->
        App.trigger 'tag:filter', text: $(event.currentTarget).children().text().trim()
        event.stopPropagation()
)


App.PlantList = PlantList = Backbone.Collection.extend(
    model: Plant
    url: '/plants/random'

    refetch: (filters)->
        if filters.activeFilters.length > 0 then type = filters.activeFilters.join("&") else type = "*"


        height = filters.height
        prize = filters.prize
        search = filters.search

        @url = "/plants/filters/#{type}/#{prize}/#{height}/#{search}"
        @fetch reset: true

)

App.PlantListView = PlantListView = Backbone.View.extend(
    tagName: 'ul'
    className: 'thumbnails'

    initialize: ()->

        # @collection.on 'add', @addOne, @
        @collection.on 'reset', @addAll, @


    render: ()->
        @addAll()
        @

    addOne: (plant)->
        plantView = new PlantView model: plant
        @$el.append plantView.render().el


    addAll: ()->
        @$el.empty()
        @collection.forEach @addOne, @



)


App.FiltersView = FiltersView = Backbone.View.extend(
    el: ".filters"

    initialize: ()->
        # @model.on 'change', @refetchPlants
        # @model.on 'change', @log, @
        @initSliders()
        App.bind 'tag:filter', @changeFilterFromTag, @

        @types = _.extend {}, @model.get("filterList").source.own.type, @model.get("filterList").source.imported.type

    log: ()->
        # console.log @model.get("activeFilters")

    events:
        "slide #prize": "changePrizeView"
        "slide #height": "changeHeightView"

        "slidestop #prize": "modifyPrize"
        "slidestop #height": "modifyHeight"

        "keyup .search": "startSearch"

        "click .type": "toggleTypeFilter"
        "click .source": "toggleSourceFilter"

    # refetchPlants: ()->
    #     console.log "LOL"


    changeFilterFromTag: (event)->
        @uncheckAllFilters()
        type = _.getTypeFromName @types, event.text
        @toggleTypeFilter type


    uncheckAllFilters: () ->
        _.each $('.type').filter('.filter-on'), (filter) ->
            $(filter).removeClass 'filter-on'
        @model.uncheckAllFilters()

    toggleTypeFilter: (event)->
        typeNode = event.currentTarget || document.getElementById event
        type = typeNode.id
        source = $(typeNode).parent().parent().attr("id")
        @model.toggleTypeFilter type, source

        if not $(typeNode).hasClass 'filter-on'
            $(typeNode).addClass 'filter-on'
        else
            $(typeNode).removeClass 'filter-on'

        event.stopPropagation?()

    toggleSourceFilter: (event)->
        source = event.currentTarget

        if not $(source).hasClass 'toggled'
            _.each $(source).children().children(".type"), (typeNode)->
                $(typeNode).addClass 'filter-on'
            $(source).addClass 'toggled'
        else
            _.each $(source).children().children(".type"), (typeNode)->
                $(typeNode).removeClass 'filter-on'
            $(source).removeClass 'toggled'

        @model.toggleSourceFilter source.id
        event.stopPropagation()

    initSliders: ()->
        $("#prize").slider
            range: "min"
            min: 100
            max: 1000
            step: 5
            value: 1000

        $("#height").slider
            range: "min"
            max: 1000
            min: 5
            step: 5
            value: 1000

    modifyPrize: (event, ui)->
        @model.modifyPrize ui.value

    modifyHeight: (event, ui)->
        @model.modifyHeight ui.value

    changePrizeView: (event, ui)->
        $(".prize-view").text ui.value

    changeHeightView: (event, ui)->
        $(".height-view").text ui.value

    startSearch: (event)->
        $("#loader").show()
        clearTimeout @loaderTimeout
        @loaderTimeout = setTimeout(
            ()=>
                @model.setSearch $(".search").val()
                $("#loader").hide()
            , 2000
        )
)


App.Filters = Filters = Backbone.Model.extend(
    uncheckAllFilters: ()->
        @set "activeFilters": []

    setSearch: (searchText)->
        @set search: searchText

    modifyPrize: (prize)->
        @set prize: prize

    modifyHeight: (height)->
        @set height: height

    toggleSourceFilter: (source)->
        typeList = @get("filterList").source[source].type
        activeFilters = _.clone @get("activeFilters")

        _.each typeList, (type)->
            indexOfType = _.indexOf activeFilters, type.name
            if indexOfType == -1
                activeFilters.push type.name

        @set "activeFilters": activeFilters
        # @change()

    toggleTypeFilter: (type, source)->
        type = @get("filterList").source[source].type[type].name
        activeFilters = _.clone @get("activeFilters")

        indexOfType = _.indexOf activeFilters, type
        if indexOfType != -1
            activeFilters.splice indexOfType, 1
        else
            activeFilters.push type

        @set "activeFilters": activeFilters
        # @trigger 'change:activeFilters', @, activeFilters


        

    defaults:
        search: ""
        prize: 1000
        height: 1000
        activeFilters: []
        filterList:
            source:
                own:
                    name: "Свои"
                    type:
                        shrubs:
                            name: "Кустарники"
                        ors:
                            name: "Многолетники с открытой корневой системой"
                imported:
                    name: "Привозные"
                    type:
                        roses:
                            name: "Розы"
                        clematis:
                            name: "Клематисы"
                        conifers:
                            name: "Хвойные"
                        perennials:
                            name: "Многолетники"
                        rhododendrons:
                            name: "Рододендроны"
                        peonies:
                            name: "Пионы"
)

# walkFilterList = (filter, fn) ->
# fn(filter)
# i = 0
# filter = filter[i]
# while(filter)
#   walkFilterList filter, fn
#   filter = filter[i++]
# 

App.PlantListApp = PlantListApp = new (Backbone.Router.extend(
    routes:
        "": "index"
        "filter/:query": "filter"
    initialize: ()->
        @filters = new Filters()
        @filtersView = new FiltersView model: @filters
        @filters.on 'change', @refetchPlants, @

        @plantList = new PlantList()
        @plantListView = new PlantListView collection: @plantList
        $('.list').html @plantListView.el

    refetchPlants: ()->
        @plantList.refetch @filters.toJSON()

    start: ()->
        Backbone.history.start pushState: true
    index: ()->
        @plantList.fetch reset: true
    filter: (filter)->
        console.log filter

))

$(()->App.PlantListApp.start())