# Install gsed
GSED_PATH=$(which gsed)
echo "GSED_PATH $GSED_PATH"
if [ "$GSED_PATH" = "" ];
then
brew install gsed
fi
