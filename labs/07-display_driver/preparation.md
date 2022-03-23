
![https://lastminuteengineers.com/seven-segment-arduino-tutorial/](../04-segment/images/7-Segment-Display-Number-Formation-Segment-Contol.png)

  ![Timing of seven-segment display](images/wavedrom_7-segment.png)

  > The figure above was created in [WaveDrom](https://wavedrom.com/) digital timing diagram online tool. The figure source code is as follows:
  >
  ```javascript
  {
    signal:
    [
      ['Digit position',
        {name: 'Common anode: AN(3)', wave: 'xx01..01..01'},
        {name: 'AN(2)', wave: 'xx101'},
        {name: 'AN(1)', wave: 'xx1.'},
        {name: 'AN(0)', wave: 'xx1.'},
      ],
      ['Seven-segment data',
        {name: '4-digit value to display', wave: 'xx3333555599', data: ['3','1','4','2','3','1','4','2','3','1']},
        {name: 'Cathod A: CA', wave: 'xx01.0.1.0.1'},
        {name: 'Cathod B: CB', wave: 'xx0.'},
        {name: 'CC', wave: 'xx0.'},
        {name: 'CD', wave: 'xx01'},
        {name: 'CE', wave: 'xx1.'},
        {name: 'CF', wave: 'xx1.'},
        {name: 'Cathod G: CG', wave: 'xx01'},
      ],
      {name: 'Decimal point: DP', wave: 'xx01..01..01'},
    ],
    head:
    {
      text: '                    4ms   4ms   4ms   4ms   4ms   4ms   4ms   4ms   4ms   4ms',
    },
  }
  ```
