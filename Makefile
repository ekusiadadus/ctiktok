.phony:

android-release:
	flutter build apk --release

android-debug:
	flutter build apk --debug

ios-release:
	flutter build ios --release

ios-debug:
	flutter build ios --debug

clean:
	flutter clean

