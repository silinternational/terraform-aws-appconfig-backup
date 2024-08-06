import { PutObjectCommand, S3Client } from "@aws-sdk/client-s3"

const client = new S3Client({})

// Lambda handler
export const handler = async (event, context) => {
  console.log(event)

  const configDataBytes = Buffer.from(event.Content, 'base64')

  // Retrieve S3 bucket name from event parameters
  const extensionAssociationParams = event.Parameters || {}
  const bucketName = extensionAssociationParams.S3_BUCKET

  const objectName = `${event.Application.Name}-${event.ConfigurationProfile.Name}`
  await writeBackupToS3(bucketName, objectName, configDataBytes)

  return {
    statusCode: 200,
    isBase64Encoded: true,
    headers: {
      "Content-Type": "application/json"
    },
    body: event.Content
  }
}

const writeBackupToS3 = async (bucketName, objectName, data) => {
  const command = new PutObjectCommand({
    Bucket: bucketName,
    Key: `${objectName}_${new Date().toISOString()}.env`,
    Body: data,
  })
  const response = await client.send(command)
  console.log(response)
}
