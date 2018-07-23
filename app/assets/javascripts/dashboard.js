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
      url: "/dashboard/testme",
      data: {frame:frame, baseAsset:baseAsset},
      success: success,
      error: function(data){ alert("error: " + response) }
    })
  } // END CandleChart
}

