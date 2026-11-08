Pod::Spec.new do |s|
  s.name                  = 'ElastosCarrierSDK'
  s.version               = '6.1.0'
  s.summary               = 'Elastos Carrier Swift SDK as shipped by Decent Network (Beagle Chat for iOS).'
  s.description           = 'P2P identity, friends, messages, offline delivery via Express, groups, file transfer and sessions on the Carrier network. Prebuilt xcframework from branch feat/agentnet-proto-v2 and native SDK v6.1.0.'
  s.homepage              = 'https://decent.network/docs/swift-carrier'
  s.license               = { :type => 'GPLv3' }
  s.author                = { 'Decent Network' => 'hi@beagle.chat' }
  s.platform              = :ios, '15.0'
  s.swift_version         = '5.0'
  s.source                = { :http => "https://github.com/0xli/Elastos.CarrierClassic.Swift/releases/download/#{s.version}/ElastosCarrierSDK.xcframework.zip",
                              :sha256 => '635e02b50d8cd7bdf2e2ee226f5cc5f7532bf28f71136069f33ab2917bf26d2d' }
  s.vendored_frameworks   = 'ElastosCarrierSDK.xcframework'
end
