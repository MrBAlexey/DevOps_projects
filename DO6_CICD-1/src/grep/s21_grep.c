#include "s21_grep.h"

#include <getopt.h>
#include <regex.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void add_pattern(arguments *arg, char *pattern) {
  if (pattern == NULL) {
    return;
  }
  int n = strlen(pattern);
  if (arg->len_pattern == 0) {
    arg->pattern = malloc(1024 * sizeof(char));
    arg->pattern[0] = '\0';
    arg->mem_pattern = 1024;
  }
  if (arg->mem_pattern < arg->len_pattern + n) {
    arg->pattern = realloc(arg->pattern, arg->mem_pattern * 2);
  }
  if (arg->len_pattern != 0) {
    strcat(arg->pattern + arg->len_pattern,
           "|"); /*strcat -добавляет копию строки А в конец строки В в место \0,
                    и добавляет в конец новой строки \0 */
    arg->len_pattern++;
  }
  arg->len_pattern +=
      sprintf(arg->pattern + arg->len_pattern, "(%s)",
              pattern); /*идентична printf(), но вывод производится в указанный
                           аргументом массив, возвращает кол-во символов
                           занесённых в массив*/
}

void regular_from_file(arguments *arg, char *path_to_file) {
  FILE *f = fopen(path_to_file, "r");
  if (f == NULL) {
    if (!arg->s) perror(path_to_file);
  }
  char *line = NULL;
  size_t memlen = 0;
  int read = getline(&line, &memlen, f);
  while (read != -1) {
    if (line[read - 1] == '\n') line[read - 1] = '\0';
    add_pattern(arg, line);
    read = getline(&line, &memlen, f);
  }
  free(line);
  fclose(f);
}

arguments argument_parser(int argc, char *argv[]) {
  arguments arg = {0};
  int opt = 0;
  while ((opt = getopt_long(argc, argv, "e:ivclnhsf:o", NULL, NULL)) != -1) {
    switch (opt) {
      case 'e': /*Шаблон начинающийся с '-'*/
        arg.e = 1;
        add_pattern(&arg, optarg); /*в optarg сохраняем regex*/
        break;
      case 'i':
        arg.i = REG_ICASE; /*flag -i, вывод данных вне зависимости от регистра
                              (регистр независимого поиска)*/
        break;
      case 'v': /*Выдает все строки, за исключением содержащих образец.*/
        arg.v = 1;
        break;
      case 'c': /*Выдает только количество строк, содержащих образец.*/
        arg.c = 1;
        break;
      case 'l': /*Выдает только имена файлов, содержащих сопоставившиеся строки,
                  по одному в строке. Если образец найден в нескольких строках
                  файла, имя файла не повторяется.*/
        arg.c = 1;
        arg.l = 1;
        break;
      case 'n':
        arg.n = 1; /*Выдает перед каждой строкой ее номер в файле (строки
                      нумеруются с 1).*/
        break;
      case 'h': /*Выводит совпадающие строки, не предваряя их именами файлов.*/
        arg.h = 1;
        break;
      case 's': /*Подавляет выдачу сообщений о не существующих или недоступных
                   для чтения файлах.*/
        arg.s = 1;
        break;
      case 'f': /*Получает регулярные выражения из файла.*/
        arg.f = 1;
        regular_from_file(&arg, optarg);
        break;
      case 'o':
        arg.o = 1; /*Печатает только совпадающие (непустые) части совпавшей
                      строки.*/
        break;
      default:
        printf(
            "usage: s21_grep [-cefhilnosv] [-e pattern] [-f file] [--null] "
            "[pattern] [file ...]");
        exit(1);
    }
  }
  if (arg.len_pattern == 0) {
    add_pattern(&arg, argv[optind]);
    optind++;
  }
  if (argc - optind == 1) {
    arg.h = 1; /*flag -h*/
  }
  return arg;
}

void line_output(char *line, int n) { /*flag e*/
  for (int i = 0; i < n; i++) {
    putchar(line[i]);
  }
  if (line[n - 1] != '\n') putchar('\n');
}

// вывод линии(строки) по символу
void match_print(regex_t *preg, char *line) {
  // структура для хранения позиции совпадения
  regmatch_t match;
  int offset = 0;
  while (1) {
    // находим совпадение в строке. Смещаемся каждый раз на offset
    int result = regexec(preg, line + offset, 1, &match, 0);

    // если совпадений нет, то завершаем цикл
    if (result != 0) break;
    /*выводим само совпадение с шаблоном используя переменные rm_so (начало
    совпадения) и rm_eo (конец совпадения)*/
    for (int i = match.rm_so; i < match.rm_eo; i++) {
      putchar(line[offset + i]);
    }
    putchar('\n');
    // двигаем наш offset чтобы продолжить со следующего места
    offset += match.rm_eo;
  }
}

// обработка файла
void processFile(arguments arg, char *path, regex_t *preg) {
  FILE *f = fopen(path, "r");
  if (f == NULL) {
    if (!arg.s)
      perror(path);  // реализ-я флага -s, который -s подавляет сообщения об
                     // ошибках о несуществующих или нечитаемых файлах.
                     // если флаг не arg.s, то выводи сообщение об ошибке. Метод
                     // от противного.
    return;
  }
  char *line = NULL;
  size_t memlen = 0;
  int read = 0;
  int line_count = 1;
  int counter = 0; /*смещение*/

  read = getline(&line, &memlen, f);
  while (read != -1) {
    int result = regexec(preg, line, 0, NULL, 0);
    if ((result == 0 && !arg.v) || (arg.v && result != 0)) { /*flag -v*/
      if (!arg.c && !arg.l) {
        if (!arg.h) printf("%s:", path);
        if (arg.n) printf("%d:", line_count); /*flag -n*/
        if (arg.o) {                          /*flag -o*/
          match_print(preg, line);
        } else {
          line_output(line, read);
        }
      }
      counter++;
    }
    read = getline(&line, &memlen, f);
    line_count++;
  }
  free(line);
  if (arg.c && !arg.l) { /*flag -c*/
    if (!arg.h) printf("%s:", path);
    printf("%d\n", counter);
  }
  if (arg.l && counter > 0)
    printf("%s\n", path), /*flag -l*/
        fclose(f);
}

// вывод из всех файлов
void output(arguments arg, int argc, char **argv) {
  // указатель на переменную preg типа regex_t, в которую будет
  // сохранено скомпилированное регулярное выражение.
  regex_t preg;
  // (ссылка на структуру, где будет сохранено скомпилированное
  // регул-е выражение; сам рег-е выраж-е; флаги, управл-ие
  // компиляцией рег-го выраж-ия)
  int error = regcomp(&preg, arg.pattern, REG_EXTENDED | arg.i); /* flag -i*/
  if (error) perror("Error");
  for (int i = optind; i < argc; i++) {
    processFile(arg, argv[i], &preg);
  }
  regfree(&preg);
}

int main(int argc, char *argv[]) {
  if (argc > 1) {
    arguments arg = argument_parser(argc, argv);
    output(arg, argc, argv);
    free(arg.pattern);
  } else
    printf(
        "usage: s21_grep [-cefhilnosv] [-e pattern] [-f file] [--null] "
        "[pattern] [file ...]");
  return 0;
}