#include "PRDRootListController.h"
#include <spawn.h>

@implementation PRDRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (id)readPreferenceValue:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	return ([settings objectForKey:specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:path atomically:YES];
}

- (void)respring {
	UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Restart SpringBoard" message:@"Restarting SpringBoard will apply all changed settings." preferredStyle:UIAlertControllerStyleActionSheet];
	
	UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
														   style:UIAlertActionStyleCancel handler:nil];
	UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"Restart SpringBoard"
															style:UIAlertActionStyleDestructive
														  handler:^(UIAlertAction* action) {
															  pid_t pid;
															  int status;
															  const char* args[] = {"killall", "-9", "SpringBoard", NULL};
															  posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
															  waitpid(pid, &status, WEXITED);
														  }];
	
	[alertController addAction:cancelAction];
	[alertController addAction:confirmAction];
	[self presentViewController:alertController animated:YES completion:nil];
}

@end
