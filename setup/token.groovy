import hudson.model.*
import jenkins.model.*
import jenkins.security.*
import jenkins.security.apitoken.*

// script parameters
def userName = 'admin'
def tokenName = 'api-token-for-webhook'

def user = User.get(userName, false)
def apiTokenProperty = user.getProperty(ApiTokenProperty.class)
def result = apiTokenProperty.tokenStore.generateNewToken(tokenName)
user.save()

def newFile = new File("/var/jenkins_home/token.txt")
newFile.write(result.plainValue)

return result.plainValue