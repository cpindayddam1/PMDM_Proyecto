import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class NotificationProvider {
  // Utilizado como Singleton para usar una única instancia
  static final NotificationProvider notificationProvider =
      NotificationProvider._();
  NotificationProvider._();

  // static int notificationID = 0;

  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> setup() async {
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSetting);
    await _localNotificationsPlugin.initialize(initSettings).then((_) {
      debugPrint('setupPlugin: setup success');
    }).catchError((Object error) {
      debugPrint('Error: $error');
    });
  }

  Future<void> mostrarNotificacionACiertaHora(int hour, int minute, String title, String body) async {
    const AndroidNotificationDetails androidDetail = AndroidNotificationDetails(
      'your_channel_id', // ID del canal de notificación
      'your_channel_name', // Nombre del canal de notificación
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidDetail);
    await _localNotificationsPlugin.showDailyAtTime(
      // Se va autoincrementando para permitir distintas notificaciones al mismo tiempo.
      //       Si queremos siempre la misma con poner un 0 basta
      0, // ID de la notificación
      title, // Título de la notificación
      body, // Cuerpo de la notificación
      Time(hour,5,5),
      platformChannelSpecifics, // Detalles de la notificación
    );
  }

  Future<void> cancelarNotificaciones() async {
    _localNotificationsPlugin.cancel(0);
  }
}
