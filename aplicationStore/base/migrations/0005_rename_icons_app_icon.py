# Generated by Django 5.0.6 on 2024-05-28 04:12

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ("base", "0004_app_app_file"),
    ]

    operations = [
        migrations.RenameField(
            model_name="app",
            old_name="icons",
            new_name="icon",
        ),
    ]
