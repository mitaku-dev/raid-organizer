class Job {
  static List<String> list() {
    return Jobs.values
        .map((job) => job.toString().split(".").last)
    .toList();
  }

  static bool isTank(String job) {
    switch(job) {
      case "drk":
      case "gnb":
      case "pld":
      case "war":
        return true;
      default:
        return false;
    }
  }

  static bool isHeal(String job) {
    switch(job) {
      case "sch":
      case "ast":
      case "whm":
        return true;
      default:
        return false;
    }
  }

}

enum Jobs {
  drk,
  gnb,
  pld,
  war,

  sch,
  ast,
  whm,

  blm,
  brd,
  dnc,
  drg,
  mch,
  mnk,
  nin,
  rdm,
  sam,
  smn,

}




