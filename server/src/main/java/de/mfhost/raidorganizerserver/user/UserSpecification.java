package de.mfhost.raidorganizerserver.user;

import org.springframework.data.jpa.domain.Specification;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

public class UserSpecification implements Specification<User> {

    private User filter;

    public UserSpecification(User filter) {
        super();
        this.filter = filter;
    }

    @Override
    public Predicate toPredicate(Root<User> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
        Predicate p = cb.disjunction();

        if (filter.getUsername() != null) {
            p.getExpressions()
                    .add(cb.like(root.get("username"), "%"+filter.getUsername()+"%"));
        }

        return p;
    }
}
