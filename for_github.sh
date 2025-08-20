#!/usr/bin/env bash
cd ..
# Скрипт инициализирует все вложенные проекты */*/ (например: for_github/C_projects/*) на гитхаб
# Параллельно создаёт на github папки с названием направления (например C_projects) и закидывает туда проекты
# Поменять name (логин на гитхабе) и privacy (private или public) 

sudo apt install -y gh
sudo apt install -y firefox
gh auth login

name="MrBAlexey"
privacy="public"

echo "Введите 'go' и нажмите Enter, когда будете готовы продолжить..."
while true; do
  read -r input
  if [[ "$input" == "go" ]]; then
    break
  else
    echo "Пожалуйста, введите 'go' чтобы продолжить."
  fi
done

for dir in ./*; do
    cd "$dir" || continue

    git init
    git add .
    git commit -m "new repository"

    repo_name=$(basename "$dir")

    # Создаём репозиторий для направления (например DevOps_projects)
    gh repo create "$name/$repo_name" --"$privacy" --confirm || echo "Репозиторий уже существует"
    project_name=$(basename "$dir")

    # Создаём репозиторий для проекта (только имя, без вложенных путей)
    gh repo create "$name/$repo_name/$project_name" --"$privacy" --confirm || echo "Репозиторий уже существует"

    git remote add origin git@github.com:$name/$project_name.git

    git push -u origin master

    cd - || exit
done


# 2. Делает репозиторий публичным/приватным

# privacy=public

# for dir in ./*/*
# do
#   repo_name=$(basename "../$dir")
#   echo "Делаем репозиторий $repo_name публичным..."
  
#   # Изменяем видимость репозитория на $privacy
#   gh repo edit MrBAlexey/${repo_name} --visibility $privacy
# done


# 3. УДАЛЯЕТ все папки .git и удаляет соответственно репозиторий с github
# Перебираем все папки (предполагаем, что имя репозитория совпадает с именем папки)
# Требует авторизации

# name="MrBAlexey"

# rm -drf ./*/*/.git
# gh auth refresh -h github.com -s delete_repo

# for dir in ./*/*
# do
#   repo_name=$(basename "$(dirname "$dir")")
#   echo "Удаляем репозиторий $repo_name..."

#   gh repo delete $name/${repo_name} --confirm
# done