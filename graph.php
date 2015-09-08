<!DOCTYPE html>
<meta charset="utf-8">
<style>
body{
    width:1060px;
    margin:50px auto;
}
path {  stroke: #fff; }
path:hover {  opacity:0.9; }
rect:hover {  fill:blue; }
.axis {  font: 10px sans-serif; }
.legend tr{    border-bottom:1px solid grey; }
.legend tr:first-child{    border-top:1px solid grey; }

.axis path,
.axis line {
  fill: none;
  stroke: #000;
  shape-rendering: crispEdges;
}

.x.axis path {  display: none; }
.legend{
    margin-bottom:76px;
    display:inline-block;
    border-collapse: collapse;
    border-spacing: 0px;
}
.legend td{
    padding:4px 5px;
    vertical-align:bottom;
}
.legendFreq, .legendPerc{
    align:right;
    width:50px;
}

</style>
<body>
<?php 
require_once 'pullData.php';
?>
<div id='dashboard'>
</div>
<script src="http://d3js.org/d3.v3.min.js"></script>
<script>
function getRandomColor() {
    var letters = '0123456789ABCDEF'.split('');
    var color = '#';
    for (var i = 0; i < 6; i++ ) {
        color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
}

function dashboard(id, fData){
    var barColor = 'steelblue';
    //function segColor(c){ return {low:"#807dba", mid:"#e08214",high:"#41ab5d"}[c]; }
	function segColor(c){ return {Other:"#807dba", Archery:"#e08214", Athletics:"#41ab5d", Badminton:getRandomColor(), Basketball:getRandomColor(), BeachVolleyball:getRandomColor(), Cycling:getRandomColor(), Diving:getRandomColor(), Equestrian:getRandomColor(), Fencing:getRandomColor(), Football:getRandomColor(), Gymnastics:getRandomColor(), Handball:getRandomColor(), Hockey:getRandomColor(), Judo:getRandomColor(), Rowing:getRandomColor(), Sailing:getRandomColor(), Shooting:getRandomColor(), Swimming:getRandomColor(), SynchronisedSwimming:getRandomColor(), TableTennis:getRandomColor(), Taekwondo:getRandomColor(), Tennis:getRandomColor(), Trampoline:getRandomColor(), Volleyball:getRandomColor(), WaterPolo:getRandomColor(), Weightlifting:getRandomColor(), Wrestling:getRandomColor()}[c]; }
    //function segColor(c){ return {Monday:"#807dba", Tuesday:"#e08214", Wednesday:"#41ab5d", Thursday:getRandomColor(), Friday:getRandomColor(), Saturday:getRandomColor(), Sunday:getRandomColor()}[c]; }
   
    // compute total for each state.
    //fData.forEach(function(d){d.total=d.freq.low+d.freq.mid+d.freq.high;});

    //{State:'Monday',freq:{Other:, Archery:, Athletics:, Badminton:, Basketball:, BeachVolleyball:, Cycling:, Diving:, Equestrian:, Fencing:, Football:, Gymnastics:, Handball:, Hockey:, Judo:, Rowing:, Sailing:, Shooting:, Swimming:, SynchronisedSwimming:, TableTennis:, Taekwondo:, Tennis:, Trampoline:, Volleyball:, WaterPolo:, Weightlifting:, Wrestling}}
    fData.forEach(function(d){d.total=d.freq.Other+d.freq.Archery+d.freq.Athletics+d.freq.Badminton+d.freq.Basketball+d.freq.BeachVolleyball+d.freq.Cycling+d.freq.Diving+d.freq.Equestrian+d.freq.Fencing+d.freq.Football+d.freq.Gymnastics+d.freq.Handball+d.freq.Hockey+d.freq.Judo+d.freq.Rowing+d.freq.Sailing+d.freq.Shooting+d.freq.Swimming+d.freq.SynchronisedSwimming+d.freq.TableTennis+d.freq.Taekwondo+d.freq.Tennis+d.freq.Trampoline+d.freq.Volleyball+d.freq.WaterPolo+d.freq.Weightlifting+d.freq.Wrestling;});
    
    //fData.forEach(function(d){d.total=d.freq.Monday+d.freq.Tuesday+d.freq.Wednesday+d.freq.Thursday+d.freq.Friday+d.freq.Saturday+d.freq.Sunday;});
    // function to handle histogram.
    function histoGram(fD){
        var hG={},    hGDim = {t: 60, r: 0, b: 30, l: 0};
        hGDim.w = 500 - hGDim.l - hGDim.r, 
        hGDim.h = 300 - hGDim.t - hGDim.b;
            
        //create svg for histogram.
        var hGsvg = d3.select(id).append("svg")
            .attr("width", hGDim.w + hGDim.l + hGDim.r)
            .attr("height", hGDim.h + hGDim.t + hGDim.b).append("g")
            .attr("transform", "translate(" + hGDim.l + "," + hGDim.t + ")");

        // create function for x-axis mapping.
        var x = d3.scale.ordinal().rangeRoundBands([0, hGDim.w], 0.1)
                .domain(fD.map(function(d) { return d[0]; }));

        // Add x-axis to the histogram svg.
        hGsvg.append("g").attr("class", "x axis")
            .attr("transform", "translate(0," + hGDim.h + ")")
            .call(d3.svg.axis().scale(x).orient("bottom"));

        // Create function for y-axis map.
        var y = d3.scale.linear().range([hGDim.h, 0])
                .domain([0, d3.max(fD, function(d) { return d[1]; })]);

        // Create bars for histogram to contain rectangles and freq labels.
        var bars = hGsvg.selectAll(".bar").data(fD).enter()
                .append("g").attr("class", "bar");
        
        //create the rectangles.
        bars.append("rect")
            .attr("x", function(d) { return x(d[0]); })
            .attr("y", function(d) { return y(d[1]); })
            .attr("width", x.rangeBand())
            .attr("height", function(d) { return hGDim.h - y(d[1]); })
            .attr('fill',barColor)
            .on("mouseover",mouseover)// mouseover is defined below.
            .on("mouseout",mouseout);// mouseout is defined below.
            
        //Create the frequency labels above the rectangles.
        bars.append("text").text(function(d){ return d3.format(",")(d[1])})
            .attr("x", function(d) { return x(d[0])+x.rangeBand()/2; })
            .attr("y", function(d) { return y(d[1])-5; })
            .attr("text-anchor", "middle");
        
        function mouseover(d){  // utility function to be called on mouseover.
            // filter for selected state.
            var st = fData.filter(function(s){ return s.State == d[0];})[0],
                nD = d3.keys(st.freq).map(function(s){ return {type:s, freq:st.freq[s]};});
               
            // call update functions of pie-chart and legend.    
            pC.update(nD);
            leg.update(nD);
        }
        
        function mouseout(d){    // utility function to be called on mouseout.
            // reset the pie-chart and legend.    
            pC.update(tF);
            leg.update(tF);
        }
        
        // create function to update the bars. This will be used by pie-chart.
        hG.update = function(nD, color){
            // update the domain of the y-axis map to reflect change in frequencies.
            y.domain([0, d3.max(nD, function(d) { return d[1]; })]);
            
            // Attach the new data to the bars.
            var bars = hGsvg.selectAll(".bar").data(nD);
            
            // transition the height and color of rectangles.
            bars.select("rect").transition().duration(500)
                .attr("y", function(d) {return y(d[1]); })
                .attr("height", function(d) { return hGDim.h - y(d[1]); })
                .attr("fill", color);

            // transition the frequency labels location and change value.
            bars.select("text").transition().duration(500)
                .text(function(d){ return d3.format(",")(d[1])})
                .attr("y", function(d) {return y(d[1])-5; });            
        }        
        return hG;
    }
    
    // function to handle pieChart.
    function pieChart(pD){
        var pC ={},    pieDim ={w:250, h: 250};
        pieDim.r = Math.min(pieDim.w, pieDim.h) / 2;
                
        // create svg for pie chart.
        var piesvg = d3.select(id).append("svg")
            .attr("width", pieDim.w).attr("height", pieDim.h).append("g")
            .attr("transform", "translate("+pieDim.w/2+","+pieDim.h/2+")");
        
        // create function to draw the arcs of the pie slices.
        var arc = d3.svg.arc().outerRadius(pieDim.r - 10).innerRadius(0);

        // create a function to compute the pie slice angles.
        var pie = d3.layout.pie().sort(null).value(function(d) { return d.freq; });

        // Draw the pie slices.
        piesvg.selectAll("path").data(pie(pD)).enter().append("path").attr("d", arc)
            .each(function(d) { this._current = d; })
            .style("fill", function(d) { return segColor(d.data.type); })
            .on("mouseover",mouseover).on("mouseout",mouseout);

        // create function to update pie-chart. This will be used by histogram.
        pC.update = function(nD){
            piesvg.selectAll("path").data(pie(nD)).transition().duration(500)
                .attrTween("d", arcTween);
        }        
        // Utility function to be called on mouseover a pie slice.
        function mouseover(d){
            // call the update function of histogram with new data.
            hG.update(fData.map(function(v){ 
                return [v.State,v.freq[d.data.type]];}),segColor(d.data.type));
        }
        //Utility function to be called on mouseout a pie slice.
        function mouseout(d){
            // call the update function of histogram with all data.
            hG.update(fData.map(function(v){
                return [v.State,v.total];}), barColor);
        }
        // Animating the pie-slice requiring a custom function which specifies
        // how the intermediate paths should be drawn.
        function arcTween(a) {
            var i = d3.interpolate(this._current, a);
            this._current = i(0);
            return function(t) { return arc(i(t));    };
        }    
        return pC;
    }
    
    // function to handle legend.
    function legend(lD){
        var leg = {};
            
        // create table for legend.
        var legend = d3.select(id).append("table").attr('class','legend');
        
        // create one row per segment.
        var tr = legend.append("tbody").selectAll("tr").data(lD).enter().append("tr");
            
        // create the first column for each segment.
        tr.append("td").append("svg").attr("width", '16').attr("height", '16').append("rect")
            .attr("width", '16').attr("height", '16')
			.attr("fill",function(d){ return segColor(d.type); });
            
        // create the second column for each segment.
        tr.append("td").text(function(d){ return d.type;});

        // create the third column for each segment.
        tr.append("td").attr("class",'legendFreq')
            .text(function(d){ return d3.format(",")(d.freq);});

        // create the fourth column for each segment.
        tr.append("td").attr("class",'legendPerc')
            .text(function(d){ return getLegend(d,lD);});

        // Utility function to be used to update the legend.
        leg.update = function(nD){
            // update the data attached to the row elements.
            var l = legend.select("tbody").selectAll("tr").data(nD);

            // update the frequencies.
            l.select(".legendFreq").text(function(d){ return d3.format(",")(d.freq);});

            // update the percentage column.
            l.select(".legendPerc").text(function(d){ return getLegend(d,nD);});        
        }
        
        function getLegend(d,aD){ // Utility function to compute percentage.
            return d3.format("%")(d.freq/d3.sum(aD.map(function(v){ return v.freq; })));
        }

        return leg;
    }


    // calculate total frequency by segment for all state.
    var tF = ['Other','Archery','Athletics','Badminton', 'Basketball', 'BeachVolleyball', 'Cycling', 'Diving', 'Equestrian', 'Fencing', 'Football', 'Gymnastics', 'Handball', 'Hockey', 'Judo', 'Rowing', 'Sailing', 'Shooting', 'Swimming', 'SynchronisedSwimming', 'TableTennis', 'Taekwondo', 'Tennis', 'Trampoline', 'Volleyball', 'WaterPolo', 'Weightlifting', 'Wrestling'].map(function(d){ 
        return {type:d, freq: d3.sum(fData.map(function(t){ return t.freq[d];}))}; 
    });    
	// var tF = ['Monday','Tuesday','Wednesday','Thursday', 'Friday', 'Saturday', 'Sunday'].map(function(d){ 
 //        return {type:d, freq: d3.sum(fData.map(function(t){ return t.freq[d];}))}; 
 //    });    
    // calculate total frequency by state for all segment.
    var sF = fData.map(function(d){return [d.State,d.total];});

    var hG = histoGram(sF), // create the histogram.
        pC = pieChart(tF), // create the pie-chart.
        leg= legend(tF);  // create the legend.
}
</script>


<script>
var freqData=[
// {State:'AL',freq:{low:4786, mid:1319, high:249}}
// ,{State:'AZ',freq:{low:1101, mid:412, high:674}}
// ,{State:'CT',freq:{low:932, mid:2149, high:418}}
// ,{State:'DE',freq:{low:832, mid:1152, high:1862}}
// ,{State:'FL',freq:{low:4481, mid:3304, high:948}}
// ,{State:'GA',freq:{low:1619, mid:167, high:1063}}
// ,{State:'IA',freq:{low:1819, mid:247, high:1203}}
// ,{State:'IL',freq:{low:4498, mid:3852, high:942}}
// ,{State:'IN',freq:{low:797, mid:1849, high:1534}}
// ,{State:'KS',freq:{low:162, mid:379, high:471}}

{State:'<30',freq:{Other:<?php echo $sportTimeLess30Count["Other"];?>, Archery:<?php echo $sportTimeLess30Count["Archery"];?>, Athletics:<?php echo $sportTimeLess30Count["Athletics"];?>, Badminton:<?php echo $sportTimeLess30Count["Badminton"];?>, Basketball:<?php echo $sportTimeLess30Count["Basketball"];?>, BeachVolleyball:<?php echo $sportTimeLess30Count["BeachVolleyball"];?>, Cycling:<?php echo $sportTimeLess30Count["Cycling"];?>, Diving:<?php echo $sportTimeLess30Count["Diving"];?>, Equestrian:<?php echo $sportTimeLess30Count["Equestrian"];?>, Fencing:<?php echo $sportTimeLess30Count["Equestrian"];?>, Football:<?php echo $sportTimeLess30Count["Football"];?>, Gymnastics:<?php echo $sportTimeLess30Count["Gymnastics"];?>, Handball:<?php echo $sportTimeLess30Count["Handball"];?>, Hockey:<?php echo $sportTimeLess30Count["Hockey"];?>, Judo:<?php echo $sportTimeLess30Count["Judo"];?>, Rowing:<?php echo $sportTimeLess30Count["Rowing"];?>, Sailing:<?php echo $sportTimeLess30Count["Sailing"];?>, Shooting:<?php echo $sportTimeLess30Count["Shooting"];?>, Swimming:<?php echo $sportTimeLess30Count["Swimming"];?>, SynchronisedSwimming:<?php echo $sportTimeLess30Count["SynchronisedSwimming"];?>, TableTennis:<?php echo $sportTimeLess30Count["TableTennis"];?>, Taekwondo:<?php echo $sportTimeLess30Count["Taekwondo"];?>, Tennis:<?php echo $sportTimeLess30Count["Tennis"];?>, Trampoline:<?php echo $sportTimeLess30Count["Trampoline"];?>, Volleyball:<?php echo $sportTimeLess30Count["Volleyball"];?>, WaterPolo:<?php echo $sportTimeLess30Count["WaterPolo"];?>, Weightlifting:<?php echo $sportTimeLess30Count["Weightlifting"];?>, Wrestling:<?php echo $sportTimeLess30Count["Wrestling"];?>}}
,{State:'30~60',freq:{Other:<?php echo $sportTimeBetween30to60Count["Other"];?>, Archery:<?php echo $sportTimeBetween30to60Count["Archery"];?>, Athletics:<?php echo $sportTimeBetween30to60Count["Athletics"];?>, Badminton:<?php echo $sportTimeBetween30to60Count["Badminton"];?>, Basketball:<?php echo $sportTimeBetween30to60Count["Basketball"];?>, BeachVolleyball:<?php echo $sportTimeBetween30to60Count["BeachVolleyball"];?>, Cycling:<?php echo $sportTimeBetween30to60Count["Cycling"];?>, Diving:<?php echo $sportTimeBetween30to60Count["Diving"];?>, Equestrian:<?php echo $sportTimeBetween30to60Count["Equestrian"];?>, Fencing:<?php echo $sportTimeBetween30to60Count["Fencing"];?>, Football:<?php echo $sportTimeBetween30to60Count["Football"];?>, Gymnastics:<?php echo $sportTimeBetween30to60Count["Gymnastics"];?>, Handball:<?php echo $sportTimeBetween30to60Count["Handball"];?>, Hockey:<?php echo $sportTimeBetween30to60Count["Hockey"];?>, Judo:<?php echo $sportTimeBetween30to60Count["Judo"];?>, Rowing:<?php echo $sportTimeBetween30to60Count["Rowing"];?>, Sailing:<?php echo $sportTimeBetween30to60Count["Sailing"];?>, Shooting:<?php echo $sportTimeBetween30to60Count["Shooting"];?>, Swimming:<?php echo $sportTimeBetween30to60Count["Swimming"];?>, SynchronisedSwimming:<?php echo $sportTimeBetween30to60Count["SynchronisedSwimming"];?>, TableTennis:<?php echo $sportTimeBetween30to60Count["TableTennis"];?>, Taekwondo:<?php echo $sportTimeBetween30to60Count["Taekwondo"];?>, Tennis:<?php echo $sportTimeBetween30to60Count["Tennis"];?>, Trampoline:<?php echo $sportTimeBetween30to60Count["Trampoline"];?>, Volleyball:<?php echo $sportTimeBetween30to60Count["Volleyball"];?>, WaterPolo:<?php echo $sportTimeBetween30to60Count["WaterPolo"];?>, Weightlifting:<?php echo $sportTimeBetween30to60Count["Weightlifting"];?>, Wrestling:<?php echo $sportTimeBetween30to60Count["Wrestling"];?>}}
,{State:'60~90',freq:{Other:<?php echo $sportTimeBetween60to90Count["Other"]?>, Archery:<?php echo $sportTimeBetween60to90Count["Archery"]?>, Athletics:<?php echo $sportTimeBetween60to90Count["Athletics"]?>, Badminton:<?php echo $sportTimeBetween60to90Count["Badminton"]?>, Basketball:<?php echo $sportTimeBetween60to90Count["Basketball"]?>, BeachVolleyball:<?php echo $sportTimeBetween60to90Count["BeachVolleyball"]?>, Cycling:<?php echo $sportTimeBetween60to90Count["Cycling"]?>, Diving:<?php echo $sportTimeBetween60to90Count["Diving"]?>, Equestrian:<?php echo $sportTimeBetween60to90Count["Equestrian"]?>, Fencing:<?php echo $sportTimeBetween60to90Count["Fencing"]?>, Football:<?php echo $sportTimeBetween60to90Count["Football"]?>, Gymnastics:<?php echo $sportTimeBetween60to90Count["Gymnastics"]?>, Handball:<?php echo $sportTimeBetween60to90Count["Handball"]?>, Hockey:<?php echo $sportTimeBetween60to90Count["Hockey"]?>, Judo:<?php echo $sportTimeBetween60to90Count["Judo"]?>, Rowing:<?php echo $sportTimeBetween60to90Count["Rowing"]?>, Sailing:<?php echo $sportTimeBetween60to90Count["Sailing"]?>, Shooting:<?php echo $sportTimeBetween60to90Count["Shooting"]?>, Swimming:<?php echo $sportTimeBetween60to90Count["Swimming"]?>, SynchronisedSwimming:<?php echo $sportTimeBetween60to90Count["SynchronisedSwimming"]?>, TableTennis:<?php echo $sportTimeBetween60to90Count["TableTennis"]?>, Taekwondo:<?php echo $sportTimeBetween60to90Count["Taekwondo"]?>, Tennis:<?php echo $sportTimeBetween60to90Count["Tennis"]?>, Trampoline:<?php echo $sportTimeBetween60to90Count["Trampoline"]?>, Volleyball:<?php echo $sportTimeBetween60to90Count["Volleyball"]?>, WaterPolo:<?php echo $sportTimeBetween60to90Count["WaterPolo"]?>, Weightlifting:<?php echo $sportTimeBetween60to90Count["Weightlifting"]?>, Wrestling:<?php echo $sportTimeBetween60to90Count["Wrestling"]?>}}
,{State:'>120',freq:{Other:<?php echo $sportTimeBetweenLarge120Count["Other"];?>, Archery:<?php echo $sportTimeBetweenLarge120Count["Archery"];;?>, Athletics:<?php echo $sportTimeBetweenLarge120Count["Athletics"];;?>, Badminton:<?php echo $sportTimeBetweenLarge120Count["Badminton"];;?>, Basketball:<?php echo $sportTimeBetweenLarge120Count["Basketball"];;?>, BeachVolleyball:<?php echo $sportTimeBetweenLarge120Count["BeachVolleyball"];;?>, Cycling:<?php echo $sportTimeBetweenLarge120Count["Cycling"];;?>, Diving:<?php echo $sportTimeBetweenLarge120Count["Diving"];;?>, Equestrian:<?php echo $sportTimeBetweenLarge120Count["Equestrian"];;?>, Fencing:<?php echo $sportTimeBetweenLarge120Count["Equestrian"];;?>, Football:<?php echo $sportTimeBetweenLarge120Count["Football"];;?>, Gymnastics:<?php echo $sportTimeBetweenLarge120Count["Gymnastics"];;?>, Handball:<?php echo $sportTimeBetweenLarge120Count["Handball"];;?>, Hockey:<?php echo $sportTimeBetweenLarge120Count["Hockey"];;?>, Judo:<?php echo $sportTimeBetweenLarge120Count["Judo"];;?>, Rowing:<?php echo $sportTimeBetweenLarge120Count["Rowing"];;?>, Sailing:<?php echo $sportTimeBetweenLarge120Count["Sailing"];;?>, Shooting:<?php echo $sportTimeBetweenLarge120Count["Shooting"];;?>, Swimming:<?php echo $sportTimeBetweenLarge120Count["Swimming"];;?>, SynchronisedSwimming:<?php echo $sportTimeBetweenLarge120Count["SynchronisedSwimming"];;?>, TableTennis:<?php echo $sportTimeBetweenLarge120Count["TableTennis"];;?>, Taekwondo:<?php echo $sportTimeBetweenLarge120Count["Taekwondo"];;?>, Tennis:<?php echo $sportTimeBetweenLarge120Count["Tennis"];;?>, Trampoline:<?php echo $sportTimeBetweenLarge120Count["Trampoline"];;?>, Volleyball:<?php echo $sportTimeBetweenLarge120Count["Volleyball"];;?>, WaterPolo:<?php echo $sportTimeBetweenLarge120Count["WaterPolo"];;?>, Weightlifting:<?php echo $sportTimeBetweenLarge120Count["Weightlifting"];;?>, Wrestling:<?php echo $sportTimeBetweenLarge120Count["Wrestling"];;?>}}
// {State:'Monday',freq:{Other:Math.floor((Math.random() * 50) + 1), Archery:Math.floor((Math.random() * 50) + 1), Athletics:Math.floor((Math.random() * 50) + 1), Badminton:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Tuesday',freq:{Other:Math.floor((Math.random() * 50) + 1), Archery:Math.floor((Math.random() * 50) + 1), Athletics:Math.floor((Math.random() * 50) + 1), Badminton:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Wednesday',freq:{Other:Math.floor((Math.random() * 50) + 1), Archery:Math.floor((Math.random() * 50) + 1), Athletics:Math.floor((Math.random() * 50) + 1), Badminton:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Thursday',freq:{Other:Math.floor((Math.random() * 50) + 1), Archery:Math.floor((Math.random() * 50) + 1), Athletics:Math.floor((Math.random() * 50) + 1), Badminton:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Friday',freq:{Other:Math.floor((Math.random() * 50) + 1), Archery:Math.floor((Math.random() * 50) + 1), Athletics:Math.floor((Math.random() * 50) + 1), Badminton:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Saturday',freq:{Other:Math.floor((Math.random() * 50) + 1), Archery:Math.floor((Math.random() * 50) + 1), Athletics:Math.floor((Math.random() * 50) + 1), Badminton:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Sunday',freq:{Other:Math.floor((Math.random() * 50) + 1), Archery:Math.floor((Math.random() * 50) + 1), Athletics:Math.floor((Math.random() * 50) + 1), Badminton:Math.floor((Math.random() * 50) + 1)}}

// {State:'Other',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Archery',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Athletics',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Badminton',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Basketball',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'BeachVolleyball',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Cycling',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Diving',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Equestrian',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Fencing',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Football',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Gymnastics',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Handball',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Hockey',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Judo',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Rowing',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Sailing',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Shooting',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Swimming',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'SynchronisedSwimming',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'TableTennis',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Taekwondo',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Tennis',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Trampoline',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Volleyball',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'WaterPolo',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Weightlifting',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}
// ,{State:'Wrestling',freq:{Monday:Math.floor((Math.random() * 50) + 1), Tuesday:Math.floor((Math.random() * 50) + 1), Wednesday:Math.floor((Math.random() * 50) + 1), Thursday:Math.floor((Math.random() * 50) + 1), Friday:Math.floor((Math.random() * 50) + 1), Saturday:Math.floor((Math.random() * 50) + 1), Sunday:Math.floor((Math.random() * 50) + 1)}}



];

dashboard('#dashboard',freqData);
</script>



 <script>






// var freqData=[

//{State:'Monday',freq:{Other:, Archery:, Athletics:, Badminton:, Basketball:, BeachVolleyball:, Cycling:, Diving:, Equestrian:, Fencing:, Football:, Gymnastics:, Handball:, Hockey:, Judo:, Rowing:, Sailing:, Shooting:, Swimming:, SynchronisedSwimming:, TableTennis:, Taekwondo:, Tennis:, Trampoline:, Volleyball:, WaterPolo:, Weightlifting:, Wrestling}}
// {State:'Tuesday',freq:{Other:, Archery:, Athletics:, Badminton:, Basketball:, BeachVolleyball:, Cycling:, Diving:, Equestrian:, Fencing:, Football:, Gymnastics:, Handball:, Hockey:, Judo:, Rowing:, Sailing:, Shooting:, Swimming:, SynchronisedSwimming:, TableTennis:, Taekwondo:, Tennis:, Trampoline:, Volleyball:, WaterPolo:, Weightlifting:, Wrestling}}
// {State:'Wednesday',freq:{Other:, Archery:, Athletics:, Badminton:, Basketball:, BeachVolleyball:, Cycling:, Diving:, Equestrian:, Fencing:, Football:, Gymnastics:, Handball:, Hockey:, Judo:, Rowing:, Sailing:, Shooting:, Swimming:, SynchronisedSwimming:, TableTennis:, Taekwondo:, Tennis:, Trampoline:, Volleyball:, WaterPolo:, Weightlifting:, Wrestling}}
// {State:'Thursday',freq:{Other:, Archery:, Athletics:, Badminton:, Basketball:, BeachVolleyball:, Cycling:, Diving:, Equestrian:, Fencing:, Football:, Gymnastics:, Handball:, Hockey:, Judo:, Rowing:, Sailing:, Shooting:, Swimming:, SynchronisedSwimming:, TableTennis:, Taekwondo:, Tennis:, Trampoline:, Volleyball:, WaterPolo:, Weightlifting:, Wrestling}}
// {State:'Friday',freq:{Other:, Archery:, Athletics:, Badminton:, Basketball:, BeachVolleyball:, Cycling:, Diving:, Equestrian:, Fencing:, Football:, Gymnastics:, Handball:, Hockey:, Judo:, Rowing:, Sailing:, Shooting:, Swimming:, SynchronisedSwimming:, TableTennis:, Taekwondo:, Tennis:, Trampoline:, Volleyball:, WaterPolo:, Weightlifting:, Wrestling}}
// {State:'Saturday',freq:{Other:, Archery:, Athletics:, Badminton:, Basketball:, BeachVolleyball:, Cycling:, Diving:, Equestrian:, Fencing:, Football:, Gymnastics:, Handball:, Hockey:, Judo:, Rowing:, Sailing:, Shooting:, Swimming:, SynchronisedSwimming:, TableTennis:, Taekwondo:, Tennis:, Trampoline:, Volleyball:, WaterPolo:, Weightlifting:, Wrestling}}
// {State:'Sunday',freq:{Other:, Archery:, Athletics:, Badminton:, Basketball:, BeachVolleyball:, Cycling:, Diving:, Equestrian:, Fencing:, Football:, Gymnastics:, Handball:, Hockey:, Judo:, Rowing:, Sailing:, Shooting:, Swimming:, SynchronisedSwimming:, TableTennis:, Taekwondo:, Tennis:, Trampoline:, Volleyball:, WaterPolo:, Weightlifting:, Wrestling}}

// {State:'Other',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Archery',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Athletics',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Badminton',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Basketball',freq:{low:797, mid:1849, high:1534}}
// ,{State:'BeachVolleyball',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Cycling',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Diving',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Equestrian',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Fencing',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Football',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Gymnastics',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Handball',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Hockey',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Judo',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Rowing',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Sailing',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Shooting',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Swimming',freq:{low:797, mid:1849, high:1534}}
// ,{State:'SynchronisedSwimming',freq:{low:797, mid:1849, high:1534}}
// ,{State:'TableTennis',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Taekwondo',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Tennis',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Trampoline',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Volleyball',freq:{low:797, mid:1849, high:1534}}
// ,{State:'WaterPolo',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Weightlifting',freq:{low:797, mid:1849, high:1534}}
// ,{State:'Wrestling',freq:{low:797, mid:1849, high:1534}}
// ];

// dashboard('#dashboard',freqData);
// </script>
