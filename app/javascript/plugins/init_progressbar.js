import ProgressBar from 'progressbar.js';

const initProgressbar = () => {

    const body = document.querySelector(".deputies-show");
    if (body) {
        
        const attendanceContainer = document.getElementById("presence")
        attendanceContainer.innerHTML = ""
        const frondingContainer = document.getElementById("fronde")
        frondingContainer.innerHTML = ""
        const filteredContainer = document.getElementById("filtered")
        if (filteredContainer) { filteredContainer.innerHTML = "" };

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
            from: {color: '#E94F37'},
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
            from: {color: '#E94F37'},
            to: {color: '#2B7178'},
            step: (state, bar) => {
              bar.setText(Math.round(bar.value() * 100) + ' %');
            }
          });
          fronding.animate(frondingRate);
    
    
          const filteredAttendanceRate = document.querySelector(".filtered-participation-rate").innerText
          const filter = new ProgressBar.SemiCircle(filtered, {
            strokeWidth: 6,
            color: '#FFEA82',
            trailColor: '#eee',
            trailWidth: 1,
            easing: 'easeInOut',
            duration: 1400,
            svgStyle: null,
            text: {
              value: '',
              alignToBottom: true
            },
            from: {color: '#E94F37'},
            to: {color: '#2B7178'},
            // Set default step function for all animate calls
            step: (state, bar) => {
              bar.path.setAttribute('stroke', state.color);
              const value = Math.round(bar.value() * 100);
              if (value === 0) {
                bar.setText('');
              } else {
                bar.setText(value + "%");
              }
          
              bar.text.style.color = state.color;
            }
          });
          filter.text.style.fontFamily = '"Raleway", Helvetica, sans-serif';
          filter.text.style.fontSize = '1.5rem';
          
          filter.animate(filteredAttendanceRate);

    };

};

export { initProgressbar };