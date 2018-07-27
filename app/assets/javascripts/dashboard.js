let App = {
  SetCandleFrame: function(frame){
    let el = document.getElementById('chartContainer')
    el.dataset.frame = frame
    App.CandleChart('NONE')
  },

  SetCandleScale: function(scale){
    let el = document.getElementById('chartContainer')
    el.dataset.scale = scale
    App.CandleChart('NONE')
  },

  CandleChart: function(baseAsset) {
    document.getElementById('chartContainerBody').hidden = false;

    let el = document.getElementById('chartContainer')
    if (baseAsset != "NONE"){ el.dataset.baseAsset = baseAsset }

    var frame = el.dataset.frame;
    var baseAsset = el.dataset.baseAsset;
    var scale = el.dataset.scale;

    let success = function(csv){
      var dataPoints = [];

      var chart = new CanvasJS.Chart("chartContainer", {
        animationEnabled: true,
        theme: "dark2", // "light1", "light2", "dark1", "dark2"
        exportEnabled: true,
        title: { text: baseAsset+"/USDT Prices" },
        subtitles: [{ text: frame+", "+(scale*100)+"%" }],
        axisX: { interval: 1, valueFormatString: "MMM" },
        axisY: { includeZero: false, prefix: "$", title: "Price" },
        toolTip: {
          content: "Date: {x}<br /><strong>Price:</strong><br />Open: {y[0]}, Close: {y[3]}<br />High: {y[1]}, Low: {y[2]}"
        },
        data: [{ type: "candlestick", yValueFormatString: "$##0.00", dataPoints: dataPoints }]
      });

      var csv_length = Math.round(csv.length - (csv.length * parseFloat(scale)))
      for (var i = csv_length; i < csv.length; i++) {
        if (csv[i].length > 0) {
          points = csv[i];
          dataPoints.push({
            x: new Date(points[0]),
            y: [
              parseFloat(points[1]),
              parseFloat(points[2]),
              parseFloat(points[3]),
              parseFloat(points[4])
            ]
          });
        }
      }
      chart.render();
    }

    $.ajax({
      type: "GET",
      url: "/dashboard/get_klines",
      data: {frame:frame, baseAsset:baseAsset},
      success: success,
      error: function(data){ alert("error: " + response) }
    })
  }, // END CandleChart

  LoadDashboard: function(){

    let success = function(data){
      let a = document.getElementById('amount_invested')
      a.innerHTML = data.amount_invested
      let b = document.getElementById('current_total')
      b.innerHTML = data.current_total
      let c = document.getElementById('profit')
      c.innerHTML = data.profit

      let table = document.getElementById('invested_coins_table')
      table.innerHTML = ""
      for(var i=0; i<data.invested_coins.length; i++){
        let ic = data.invested_coins[i]
        table.innerHTML += `
          <tr onclick="App.CandleChart('`+ic.baseAsset+`')">
            <td class="text-center">`+ic.baseAsset+`</td>
            <td class="text-right">`+ic.price+`</td>
            <td class="text-right">`+ic.amount+`</td>
            <td class="text-right">`+ic.usd+`</td>
          </tr>
        `;
      }
    }

    let pollFunc = function(){
      $.ajax({
        type: "GET",
        url: "/dashboard/get_data",
        success: success,
        error: function(data){ alert("error: " + data) }
      })
    }

    pollFunc()
    setInterval(pollFunc, 30000)
  }

}

