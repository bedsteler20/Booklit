module.exports = {
  publishers: [
    {
      name: '@electron-forge/publisher-s3',
      platforms: ['darwin', 'linux'],
      config: {
        bucket: 'my-bucket',
        folder: 'my/key/prefix'
      }
    }
  ]
}