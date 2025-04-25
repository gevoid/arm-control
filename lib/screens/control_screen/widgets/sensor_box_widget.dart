part of '../control_screen.dart';

class _SensorDataBox extends ConsumerStatefulWidget {
  const _SensorDataBox();

  @override
  ConsumerState<_SensorDataBox> createState() => _SensorDataBoxState();
}

class _SensorDataBoxState extends ConsumerState<_SensorDataBox> {
  @override
  Widget build(BuildContext context) {
    double tempValue = ref.watch(generalProvider.select((g) => g.tempValue));
    double distanceValue = ref.watch(
      generalProvider.select((g) => g.distanceValue),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white10,
                border:
                    tempValue > 30
                        ? tempValue < 50
                            ? Border.all(color: Colors.amber, width: 2)
                            : Border.all(color: Colors.red, width: 2)
                        : null,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                      children: [
                        Text(
                          'Sıcaklık',
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 3),
                        AnimatedRadialGauge(
                          /// The animation duration.
                          duration: const Duration(seconds: 1),
                          curve: Curves.linear,

                          /// Define the radius.
                          /// If you omit this value, the parent size will be used, if possible.
                          radius: 60,

                          builder: (context, child, value) {
                            return Center(
                              child: Text(
                                '$tempValue°',
                                style: TextStyle(color: Colors.white70),
                              ),
                            );
                          },

                          /// Gauge value.
                          value: tempValue,

                          /// Optionally, you can configure your gauge, providing additional
                          /// styles and transformers.
                          axis: GaugeAxis(
                            /// Provide the [min] and [max] value for the [value] argument.
                            min: 0,
                            max: 100,

                            /// Render the gauge as a 180-degree arc.
                            degrees: 180,

                            /// Set the background color and axis thickness.
                            style: const GaugeAxisStyle(
                              thickness: 10,
                              background: Colors.transparent,
                              segmentSpacing: 4,
                            ),

                            /// Define the pointer that will indicate the progress (optional).
                            pointer: GaugePointer.needle(
                              position: GaugePointerPosition.surface(
                                offset: Offset(1, 12),
                              ),
                              borderRadius: 16,
                              width: 15,
                              height: 20,
                              border: GaugePointerBorder(
                                color: Colors.blueGrey,
                                width: 2,
                              ),
                              color: Colors.black,
                            ),

                            /// Define axis segments (optional).
                            segments: [
                              const GaugeSegment(
                                from: 0,
                                to: 30,
                                color: Colors.green,
                                cornerRadius: Radius.zero,
                              ),
                              const GaugeSegment(
                                from: 30,
                                to: 50,
                                color: Colors.amber,
                                cornerRadius: Radius.zero,
                              ),
                              const GaugeSegment(
                                from: 50,
                                to: 100,
                                color: Colors.red,
                                cornerRadius: Radius.zero,
                              ),
                            ],

                            progressBar: null,
                          ),
                        ),

                        //  Text('$tempValue°', style: TextStyle(color: Colors.green)),
                        // SizedBox(height: 6),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 6),
            Container(
              decoration: BoxDecoration(
                color: Colors.white10,
                border:
                    distanceValue < 12 && distanceValue != 0
                        ? distanceValue > 8
                            ? Border.all(color: Colors.amber, width: 2)
                            : Border.all(color: Colors.red, width: 2)
                        : null,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                      children: [
                        Text(
                          'Uzaklık',
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 3),
                        AnimatedRadialGauge(
                          /// The animation duration.
                          duration: const Duration(seconds: 1),
                          curve: Curves.linear,

                          /// Define the radius.
                          /// If you omit this value, the parent size will be used, if possible.
                          radius: 60,

                          builder: (context, child, value) {
                            return Center(
                              child: Text(
                                '${distanceValue}cm',
                                style: TextStyle(color: Colors.white70),
                              ),
                            );
                          },

                          /// Gauge value.
                          value: distanceValue,

                          /// Optionally, you can configure your gauge, providing additional
                          /// styles and transformers.
                          axis: GaugeAxis(
                            /// Provide the [min] and [max] value for the [value] argument.
                            min: 0,
                            max: 100,

                            /// Render the gauge as a 180-degree arc.
                            degrees: 180,

                            /// Set the background color and axis thickness.
                            style: const GaugeAxisStyle(
                              thickness: 10,
                              background: Colors.transparent,
                              segmentSpacing: 4,
                            ),

                            /// Define the pointer that will indicate the progress (optional).
                            pointer: GaugePointer.needle(
                              position: GaugePointerPosition.surface(
                                offset: Offset(1, 12),
                              ),
                              borderRadius: 16,
                              width: 15,
                              height: 20,
                              border: GaugePointerBorder(
                                color: Colors.blueGrey,
                                width: 2,
                              ),
                              color: Colors.black,
                            ),

                            /// Define axis segments (optional).
                            segments: [
                              const GaugeSegment(
                                from: 0,
                                to: 8,
                                color: Colors.red,
                                cornerRadius: Radius.zero,
                              ),
                              const GaugeSegment(
                                from: 8,
                                to: 12,
                                color: Colors.amber,
                                cornerRadius: Radius.zero,
                              ),
                              const GaugeSegment(
                                from: 12,
                                to: 100,
                                color: Colors.green,
                                cornerRadius: Radius.zero,
                              ),
                            ],

                            progressBar: null,
                          ),
                        ),

                        //  Text('$tempValue°', style: TextStyle(color: Colors.green)),
                        // SizedBox(height: 6),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        _connectionStatusText(),
      ],
    );
  }

  Text _connectionStatusText() {
    bool isConnected = ref.watch(generalProvider.select((g) => g.isConnected));

    return Text(
      isConnected ? '◉ Wİ-Fİ Bağlı' : '◉ Wİ-Fİ Bağlı Değil',
      style: TextStyle(
        color: isConnected ? Colors.green : Colors.red,
        fontSize: 12,
      ),
    );
  }
}
