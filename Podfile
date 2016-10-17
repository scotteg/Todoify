use_frameworks!

target 'Todoify' do
    pod 'Realm', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true
    pod 'RealmSwift', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true

    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end
end
