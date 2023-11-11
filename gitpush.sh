#!/bin/bash

# ファイルをステージングエリアに追加
git add .

# コミットメッセージとともにコミット
git commit -m 'exp'

# developブランチにプッシュ
git push origin develop

# publish
dart pub publish
