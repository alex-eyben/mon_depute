import ProgressBar from 'progressbar.js';

const initProgressbar = () => {
    const attendanceRate = document.querySelector(".participation-rate").innerText
    const attendance = new ProgressBar.Line(presence, {
        strokeWidth: 4,
        easing: 'easeInOut',
        duration: 1400,
        color: '#2B7178',
        trailColor: '#eee',
        trailWidth: 1,
        svgStyle: {width: '100%', height: '100%'},
        text: {
          style: {
            // Text color.
            // Default: same as stroke color (options.color)
            color: '#999',
            position: 'absolute',
            right: '0',
            top: '30px',
            padding: 0,
            margin: 0,
            transform: null
          },
          autoStyleContainer: false
        },
        from: {color: '#2B7178'},
        to: {color: '#2B7178'},
        step: (state, bar) => {
          bar.setText(Math.round(bar.value() * 100) + ' %');
        }
      });
      attendance.animate(attendanceRate);

      const frondingRate = document.querySelector(".fronding-rate").innerText
      const fronding = new ProgressBar.Line(fronde, {
        strokeWidth: 4,
        easing: 'easeInOut',
        duration: 1400,
        color: '#2B7178',
        trailColor: '#eee',
        trailWidth: 1,
        svgStyle: {width: '100%', height: '100%'},
        text: {
          style: {
            // Text color.
            // Default: same as stroke color (options.color)
            color: '#999',
            position: 'absolute',
            right: '0',
            top: '30px',
            padding: 0,
            margin: 0,
            transform: null
          },
          autoStyleContainer: false
        },
        from: {color: '#2B7178'},
        to: {color: '#2B7178'},
        step: (state, bar) => {
          bar.setText(Math.round(bar.value() * 100) + ' %');
        }
      });
      fronding.animate(frondingRate);


      const filteredAttendanceRate = document.querySelector(".filtered-participation-rate").innerText
      const filter = new ProgressBar.Line(filtered, {
        strokeWidth: 4,
        easing: 'easeInOut',
        duration: 1400,
        color: '#2B7178',
        trailColor: '#eee',
        trailWidth: 1,
        svgStyle: {width: '100%', height: '100%'},
        text: {
          style: {
            // Text color.
            // Default: same as stroke color (options.color)
            color: '#999',
            position: 'absolute',
            right: '0',
            top: '30px',
            padding: 0,
            margin: 0,
            transform: null
          },
          autoStyleContainer: false
        },
        from: {color: '#2B7178'},
        to: {color: '#2B7178'},
        step: (state, bar) => {
          bar.setText(Math.round(bar.value() * 100) + ' %');
        }
      });
      filter.animate(filteredAttendanceRate);
};

export { initProgressbar };